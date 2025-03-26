from pydantic import BaseModel
from datetime import date

class CustomerCreate(BaseModel):
    customer_name: str
    credit_note: str
    date: date
    sales_incharge: str
    reason_status: str
    credit_amount: float
