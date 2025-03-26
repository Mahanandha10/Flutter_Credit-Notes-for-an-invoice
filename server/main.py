from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
import psycopg2
from psycopg2.extras import RealDictCursor

app = FastAPI()

def get_db_connection():
    conn = psycopg2.connect(
        dbname="assignment",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )
    return conn

class CustomerData(BaseModel):
    name: str
    credit_note: str
    date: str
    sales_incharge: str
    reason: str
    credit_amount: float

@app.post("/submit-customer/")
async def submit_customer_data(data: CustomerData):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        query = """
        INSERT INTO customers (name, credit_note, date, sales_incharge, reason, credit_amount) 
        VALUES (%s, %s, %s, %s, %s, %s) RETURNING id;
        """
        cursor.execute(query, (data.name, data.credit_note, data.date, data.sales_incharge, data.reason, data.credit_amount))
        conn.commit()
        
        inserted_id = cursor.fetchone()["id"]
        cursor.close()
        conn.close()
        
        return {"message": "Customer data submitted successfully!", "id": inserted_id}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
