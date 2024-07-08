import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text


def dataframe_to_postgres(dataframe, psql_config, table_name):
    # Create a connection string
    conn_str = (
        "postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}".format(
            **psql_config
        )
    )

    # Create a SQLAlchemy engine
    engine = create_engine(conn_str)

    # Execute the SQL query and fetch the result into a Pandas DataFrame
    dataframe.to_sql(table_name, engine, if_exists="replace", index=False)


def query_to_dataframe(sql_query, psql_config):
    # Create a connection string
    conn_str = (
        "postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}".format(
            **psql_config
        )
    )

    # Create a SQLAlchemy engine
    engine = create_engine(conn_str)

    # Execute the SQL query and fetch the result into a Pandas DataFrame
    with engine.connect() as conn:
        df = pd.read_sql(text(sql_query), conn)

    return df
