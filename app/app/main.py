from fastapi import FastAPI, Depends

import requests

from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.ext.declarative import declarative_base

from prometheus_client import start_http_server, Counter

from os import environ


app = FastAPI()

ip_lookup_counter = Counter('ip_lookup_counter', 'Number of IP lookups')

db_host = environ.get("postgresql_hostname")
db_name = environ.get("postgresql_database")
db_user = environ.get("postgresql_username")
db_pass = environ.get("postgresql_password")

engine = create_engine(f'postgresql://{db_user}:{db_pass}@{db_host}/{db_name}')
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class IPInfo(Base):
    __tablename__ = 'ip_info'
    id = Column(Integer, primary_key=True, index=True)
    ip_address = Column(String, unique=True, index=True)
    country = Column(String)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/ip-lookup/{ip_address}")
def ip_lookup(ip_address, db: Session = Depends(get_db)):
    ip = ip_address
    url = f"http://ip-api.com/json/{ip}?fields=country"

    query_result = db.query(IPInfo).filter(IPInfo.ip_address == ip_address).first()

    if query_result is None:
        try:
            response = requests.get(url)
            data = response.json()
            country = data.get('country', False)
        except requests.exceptions.RequestException as e:
            country = False

        ip_info = IPInfo(ip_address=ip, country=country)
        db.add(ip_info)
        db.commit()
        db.refresh(ip_info)
    else:
        country = query_result.country

    ip_lookup_counter.inc()
    
    return {'country': country}

start_http_server(8001)
