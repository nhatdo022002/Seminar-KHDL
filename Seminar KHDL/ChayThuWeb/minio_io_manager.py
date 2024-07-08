import os
from io import BytesIO

import pandas as pd

from minio import Minio


def load_files_to_minio(client, directory_path, bucket_name, key_prefix=""):
    if not client.bucket_exists(bucket_name):
        print(f"{bucket_name} does not exist")
        print(f"Create bucket {bucket_name}")
        client.make_bucket(bucket_name)
    else:
        print(f"{bucket_name} exists")

    for file_name in os.listdir(directory_path):
        file_path = os.path.join(directory_path, file_name)

        if os.path.isfile(file_path):
            object_name = key_prefix + file_name
            client.fput_object(bucket_name, object_name, file_path)
            print(f"File uploaded successfully: {object_name}")


def raw_data_in_minio(client, bucket_name):
    # load to a list
    objects = client.list_objects(bucket_name, recursive=True)
    object_list = []
    for obj in objects:
        object_list.append(obj.object_name)

    return object_list


def load_data_from_MinIO(client, file_name, bucket_name):
    # Lấy nội dung của đối tượng từ MinIO
    response = client.get_object(bucket_name, file_name)

    # Đọc nội dung trực tiếp từ bộ đệm bộ nhớ sử dụng pandas
    df = pd.read_csv(BytesIO(response.read()), sep="\t", low_memory=False)
    return df
