from sqlalchemy import Column, Integer, String, Float, Date
from database import Base

class Customer(Base):
    __tablename__ = "customers"

    id = Column(Integer, primary_key=True, index=True)
    customer_name = Column(String, nullable=False)
    credit_note = Column(String, nullable=False)
    date = Column(Date, nullable=False)
    sales_incharge = Column(String, nullable=False)
    reason_status = Column(String, nullable=False)
    credit_amount = Column(Float, nullable=False)
