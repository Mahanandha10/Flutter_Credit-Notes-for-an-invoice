from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from fastapi.middleware.cors import CORSMiddleware

DATABASE_URL = "postgresql://postgres:1234@localhost:5432/assignment"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()

class Customer(Base):
    __tablename__ = "customers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    date = Column(String, nullable=False)
    sales_incharge = Column(String, nullable=False)
    reason = Column(String, nullable=False)
    credit_amount = Column(Float, nullable=False)

Base.metadata.create_all(bind=engine)


class CustomerCreate(BaseModel):
    name: str
    date: str
    sales_incharge: str
    reason: str
    credit_amount: float

# Initialize FastAPI app
app = FastAPI()

# Enable CORS for Flutter requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (change this in production)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# API route to store customer data in PostgreSQL
@app.post("/submit-form")
def create_customer(customer: CustomerCreate, db: Session = Depends(get_db)):
    db_customer = Customer(
        name=customer.name,
        date=customer.date,
        sales_incharge=customer.sales_incharge,
        reason=customer.reason,
        credit_amount=customer.credit_amount,
    )
    db.add(db_customer)
    db.commit()
    db.refresh(db_customer)
    
    return {"message": "Customer added successfully", "customer": db_customer}
