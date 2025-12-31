import pandas as pd
import sqlalchemy
from faker import Faker
import uuid
import random
from datetime import datetime, timedelta

# ==========================================
# KONFIGURASI DATABASE (SESUAIKAN DISINI!)
# ==========================================
# Format: postgresql://username:password@host:port/database_name
DB_CONNECTION_STR = 'postgresql://neondb_owner:npg_Futem9f8kxqD@ep-summer-mouse-ahm82av2-pooler.c-3.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require''

# Inisialisasi Faker dan Koneksi Database
fake = Faker()
engine = sqlalchemy.create_engine(DB_CONNECTION_STR)

def generate_fake_data(num_orders=5):
    print(f"🔄 Sedang membuat {num_orders} transaksi palsu...")

    new_orders = []
    new_items = []

    for _ in range(num_orders):
        # 1. GENERATE ORDER BARU
        order_id = str(uuid.uuid4())
        customer_id = str(uuid.uuid4())
        
        # Waktu beli = Sekarang
        purchase_time = datetime.now()
        
        # Estimasi logika tanggal (biar masuk akal)
        approved_time = purchase_time + timedelta(minutes=random.randint(5, 60))
        delivered_carrier_time = approved_time + timedelta(hours=random.randint(2, 24))
        # Estimasi sampai 3 hari lagi
        estimated_delivery = purchase_time + timedelta(days=3)
        
        
        order_data = {
            'order_id': order_id,
            'customer_id': customer_id,
            'order_status': 'delivered', # Anggap langsung sukses biar masuk report
            'order_purchase_timestamp': purchase_time,
            'order_approved_at': approved_time,
            'order_delivered_carrier_date': delivered_carrier_time,
            'order_delivered_customer_date': None, # Ceritanya barang masih di jalan (OTW)
            'order_estimated_delivery_date': estimated_delivery
        }
        new_orders.append(order_data)

        # 2. GENERATE ITEM UNTUK ORDER TERSEBUT
        # Satu order bisa beli 1-3 barang
        num_items_in_cart = random.randint(1, 3)
        
        for i in range(1, num_items_in_cart + 1):
            item_data = {
                'order_id': order_id,
                'order_item_id': i,
                'product_id': str(uuid.uuid4()), # Random Product
                'seller_id': str(uuid.uuid4()),  # Random Seller
                'shipping_limit_date': estimated_delivery,
                'price': round(random.uniform(10.0, 500.0), 2), # Harga random 10 - 500
                'freight_value': round(random.uniform(5.0, 50.0), 2) # Ongkir random
            }
            new_items.append(item_data)

    # 3. SIMPAN KE DATABASE (APPEND)
    
    # Simpan Orders
    if new_orders:
        df_orders = pd.DataFrame(new_orders)
        # Masukkan ke tabel 'raw_orders'. if_exists='append' artinya nambah, bukan hapus.
        df_orders.to_sql('raw_orders', engine, if_exists='append', index=False)
        print(f"✅ Berhasil menambah {len(new_orders)} pesanan ke raw_orders.")

    # Simpan Items (PENTING: Biar Revenue bertambah)
    if new_items:
        df_items = pd.DataFrame(new_items)
        df_items.to_sql('raw_items', engine, if_exists='append', index=False)
        print(f"✅ Berhasil menambah {len(new_items)} barang ke raw_items.")

if __name__ == "__main__":
    # Jalankan fungsi: Buat 10 pesanan baru
    generate_fake_data(10)