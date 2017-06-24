import pandas as pd
import sqlalchemy
import json

class DbCon:
    db_conn = None
    db_info_tables = ['Accounts']
    db_info_fields = {'Accounts': ['Account_ID', 'Username', 'pDonaterRank', 'Score', 'Kills', 'Deaths']}
    db_dfs = {}

    def __init__(self):
        with open('conf.json', 'r') as f:
            self.db_info = json.loads(f.read())
        self.db_info['tables'] = self.db_info_tables
        self.db_info['fields'] = self.db_info_fields

        self.db_conn = sqlalchemy.create_engine(
            'mysql://' + self.db_info['user'] + ':' + self.db_info['password'] + '@' + self.db_info['server'] + ':' +
            self.db_info['port'] + '/' + self.db_info['database'])
        self.read_data()

    def read_data(self):
        for table in self.db_info['tables']:
            q = "SELECT " + ", ".join(self.db_info['fields'][table]) + " FROM " + table + ";"
            self.db_dfs[table] = pd.read_sql_query(q, self.db_conn, index_col='Account_ID')

    def get_accounts(self):
        return self.db_dfs['Accounts'] if 'Accounts' in self.db_dfs.keys() else None

    def get_score_highest_10(self):
        df = self.get_accounts()
        return df.nlargest(10, 'Score')

    def get_score_lowest_10(self):
        df = self.get_accounts()
        return df.nsmallest(10, 'Score', 'last')

    def get_kd_highest_10(self):
        df = self.get_accounts()
        df = df[df['Kills'] > 10]
        df = df[df['Deaths'] > 10]
        df['kd_ratio'] = df['Kills'] / df['Deaths']
        return df.nlargest(10, 'kd_ratio')

    def get_kd_lowest_10(self):
        df = self.get_accounts()
        df = df[df['Kills'] > 10]
        df = df[df['Deaths'] > 10]
        df['kd_ratio'] = df['Kills'] / df['Deaths']
        return df.nsmallest(10, 'kd_ratio', 'last')