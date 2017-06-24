import pandas as pd
import sqlalchemy
import json
import numpy as np

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
        if 'Accounts' in self.db_dfs.keys():
            df = self.db_dfs['Accounts']
            df['kd_ratio'] = df['Kills'] / df['Deaths']
            return df
        else:
            return None

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
        return df.nlargest(10, 'kd_ratio')

    def get_kd_lowest_10(self):
        df = self.get_accounts()
        df = df[df['Kills'] > 10]
        df = df[df['Deaths'] > 10]
        return df.nsmallest(10, 'kd_ratio', 'last')

    def get_names(self):
        df = self.get_accounts()
        return df['Username']

    def get_player_info(self, player):
        def change_donator_values(df):
            donatorvalues = list(df['pDonaterRank'])
            donatorRanks = ['Not', 'Donator', 'Premium Donator', 'Deluxe Donator']
            for n, i in enumerate(donatorvalues):
                donatorvalues[n] = donatorRanks[i]
            df['Donator'] = donatorvalues
            return df
        df = self.get_accounts()
        df['Donator'] = np.nan
        df = change_donator_values(df)
        return df[df['Username'] == player]