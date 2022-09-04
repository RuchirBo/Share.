# This is a sample Python script.
# note: add ability to sell some shares (not all)
# need error checking for if price is valid, if day is valid

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

from flask import Flask, jsonify
import yahoo_fin.stock_info as si
import pandas as pd
import datetime as dt
from flask_restful import Resource, Api, reqparse
import ast
import csv
import requests as req
import json

app = Flask(__name__)
api = Api(app)

# class Post:
#     def __init__(self, text, likes):
#         self.text = text
#         self.likes = 0
#         self.date = dt.today()
#
#     def like(self):
#         self.likes += 1

# # class for purchases
# class Purchase:
#     def __init__(self, date, ticker, cost, shares):
#         self.date = date                                                        # date purchased
#         self.ticker = ticker                                                    # stock ticker
#         self.i_cost = cost                                                      # cost of share at purchase time
#         self.shares = shares                                                    # number of shares bought
#         self.t_cost = self.i_cost * self.shares                                 # total cost of initial purchase
#         self.value = round(si.get_quote_table("aapl")["Quote Price"], 2)        # current value of share
#         self.t_value = round(self.value * self.shares, 2)                       # current value of all shares
#         self.p_gain = round((self.value - self.i_cost) / self.i_cost, 4) * 100  # percentage gain or loss
#         self.m_gain = round((self.t_value - self.t_cost) / self.t_cost, 2)      # amount gain or loss
#         self.active = True                                                      # stock is sold or not
#
#     # updates current cost and current gain
#     def update_value(self):
#         if self.active == False:
#             raise Exception(self.ticker + "has already been sold")
#         self.value = round(si.get_quote_table("aapl")["Quote Price"], 2)
#         self.p_gain = round((self.value - self.i_cost) / self.i_cost, 4) * 100
#         self.t_value = self.value * self.shares
#         self.m_gain = round((self.t_value - self.t_cost) / self.t_cost, 2)
#
#     # sell all shares
#     def sell(self):
#         if self.active == False:
#             raise Exception(self.ticker + "has already been sold")
#         self.update_value()
#         self.active = False
#
#     def graph1week(self, ):
#         points = []
#         tickers = []
#         # for purchase in self.purchases:
#
#
#

# basic User Class
# class User():
#     def __init__(self, username, password):
#         self.username = username        # setting user
#         self.password = password        # setting password
#         self.purchases = []             # list of purchase
#         self.p_gain = 0                 # gain or loss percent of person
#
#     # initializing a stock purchase
#     def log_purchase(self, date, ticker, cost, shares):
#
#         self.purchases.append(Purchase(date, ticker, cost, shares))
#
#     # calculate current gain of user
#     def curr_gain(self):
#         t_cost = 0
#         t_gain = 0
#         for purchase in self.purchases:
#             t_cost += purchase.t_cost
#             t_gain += purchase.t_value
#         self.p_gain = round((t_gain - t_cost) / t_cost, 4) * 100
#         return self.p_gain
#
#     def find_purchase(self, date, ticker, cost):
#         for purchase in self.purchases:
#             if purchase.date == date and purchase.ticker == ticker and purchase.cost == cost:
#                 return purchase
#         raise Exception("Purchase not found")
#
#     def sell(self, date, ticker, cost):
#         purchase = self.find_purchase(date, ticker, cost)
#         purchase.sell()
#
#     # function to graph data from one week, iterate through, create a dataframe with every

class Users(Resource):

    def post(self):
        parser = reqparse.RequestParser()  # initialize

        parser.add_argument('username', location='args', required=True)
        parser.add_argument('password', location='args', required=True)

        args = parser.parse_args()  # parse arguments to dictionary
        username = args['username']
        password = args['password']

        # read our CSV
        data = pd.read_csv('users.csv')

        if args['username'] in list(data['username']):
            return {
                'message': f"'{args['username']}' already exists."
            }, 401

        else:

            header = ['date', 'ticker', 'cost', 'share', 'value']

            with open(username + '.csv', 'w', encoding='UTF8') as f:
                writer = csv.writer(f)

                # write the header
                writer.writerow(header)

            new = {
                'username' : [username],
                'password' : [password],
                'csv' : username + '.csv'
            }
            new_data = pd.DataFrame(new)
            # add the newly provided values
            data = data.append(new_data, ignore_index=True)
            # save back to CSV
            data.to_csv('users.csv', index=False)

        return args['username'], 200  # return data with 200 OK

    def put(self):
        parser = reqparse.RequestParser()  # initialize
        parser.add_argument('username', location='args', required=True)  # add args
        parser.add_argument('date', location='args', required=True)
        parser.add_argument('ticker', location='args', required=True)
        parser.add_argument('cost', location='args', required=True)
        parser.add_argument('shares', location='args', required=True)
        args = parser.parse_args()  # parse arguments to dictionary

        # read our CSV
        data = pd.read_csv('users.csv')

        if args['username'] in list(data['username']):
            row = data.loc[data['username'] == args['username']]
            file = pd.read_csv(row.iloc[0]['csv'])


            date = args['date']
            ticker = args['ticker']
            cost = args['cost']
            shares = args['shares']
            value = round(si.get_quote_table(ticker)["Quote Price"], 2)

            new = {
                'date' : [date],
                "ticker" : [ticker],
                "cost" : [float(cost)],
                "shares" : [int(shares)],
                'value' : [value],
                'active' : [True]
            }

            new_data = pd.DataFrame(new)
            # add the newly provided values
            file = file.append(new_data, ignore_index=True)
            file['t_cost'] = file['cost'] * file['shares']
            file['t_value'] = file['value'] * file['shares']
            file['p_gain'] = round(round((file['value'] - file['cost']) / file['cost'], 6) * 100, 2)
            file['m_gain'] = round((file['t_value'] - file['t_cost']) / file['t_cost'], 2)
            # save back to CSV
            file.to_csv(row.iloc[0]['csv'], index=False)

            # save back to CSV
            data.to_csv('users.csv', index=False)
            # return data and 200 OK
            return {'data': data.to_dict()}, 200

        else:
            # otherwise the userId does not exist
            return {
                'message': f"'{args['username']}' user not found."
            }, 404

    def get(self):
        # read our CSV
        data = pd.read_csv('users.csv')

        parser = reqparse.RequestParser()  # initialize

        parser.add_argument('username', location='args', required=True)
        args = parser.parse_args()

        if args['username'] in list(data['username']):
            row = data.loc[data['username'] == args['username']]
            file = pd.read_csv(row.iloc[0]['csv'])
            file['value'] = round(si.get_quote_table(file['ticker'][0])["Quote Price"], 2)
            file['t_cost'] = file['cost'] * file['shares']
            file['t_value'] = file['value'] * file['shares']
            file['p_gain'] = round(round((file['value'] - file['cost']) / file['cost'], 6) * 100, 2)
            file['m_gain'] = round((file['t_value'] - file['t_cost']) / file['t_cost'], 2)
            t_value = pd.Series(file['t_value']).sum()
            t_cost = pd.Series(file['t_cost']).sum()
            file.to_csv(row.iloc[0]['csv'], index=False)
            return {'profitpercent' : round(round((t_value - t_cost) / t_cost, 6) * 100, 2)}, 200
        else:
            # otherwise the userId does not exist
            return {
                'message': f"'{args['username']}' user not found."
            }, 404

class Messages(Resource):
    def get(self):
        data = pd.read_csv('messages.csv')
        data = data.to_dict()  # convert dataframe to dictionary
        return {'data': data}, 200  # return data and 200 OK code

    def post(self):

        data = pd.read_csv('messages.csv')
        parser = reqparse.RequestParser()  # initialize

        parser.add_argument('username', location='args', required=True)
        parser.add_argument('text', location='args', required=True)

        args = parser.parse_args()

        text = (args['text'])

        new = {
                "username" : [args['username']],
                "text" : [text],
                "comments" : [[]],
                "likes" : 0
            }

        new_data = pd.DataFrame(new)

        data = data.append(new_data, ignore_index=True)
        # save back to CSV
        data.to_csv('messages.csv', index=False)

        return {'data': data.to_dict()}, 200  # return data with 200 OK

    def put(self):
        data = pd.read_csv('messages.csv')
        parser = reqparse.RequestParser()  # initialize
        parser.add_argument('username', location='args', required=True)
        parser.add_argument('text', location='args', required=True)
        parser.add_argument('action', location='args', required=True)
        # parser.add_argument('commenter', location='args', required=False)
        # parser.add_argument('ctext', location='args', required=False)
        args = parser.parse_args()

        if args['action'] == 'like':
            row = data[(data['text'] == args['text']) & (data['username'] == args['username'])].index
            data.at[row[0], 'likes'] += 1
            data.to_csv('messages.csv', index=False)
            d = data.to_dict()
            return d, 200
        # elif args['action'] == 'comment':
        #     row = data[(data['text'] == args['text']) & (data['username'] == args['username'])].index
        #     print(data.at[row[0], 'comments'])
        #     data.at[row[0], 'comments'] = ast.literal_eval(data.at[row[0], 'comments']).append([(args['commenter'], args['ctext'])])
        #     print(data.at[row[0], 'comments'])
        #     # print(row['comments'])
        #     # row['comments'][0] = ast.literal_eval(row['comments'][0])
        #     # row['comments'][0] = row['comments'][0].append((args['commenter'], args['ctext']))
        #     # print(row['comments'][0])
        #     # data.to_csv('messages.csv', index=False)
        #     d = data.to_dict()
        #     return d, 200

        return {'message': "Message not found"}, 404

class Groups(Resource):
    def post(self):
        parser = reqparse.RequestParser()  # initialize

        parser.add_argument('username', location='args', required=True)
        parser.add_argument('group', location='args', required=True)

        args = parser.parse_args()  # parse arguments to dictionary
        username = args['username']
        group = args['group']
        filename = group + '.csv'

        try:
           fn=open(filename,"U")
        except IOError:
            header = ['username', 'percentage']

            with open(filename, 'w', encoding='UTF8') as f:
                writer = csv.writer(f)

                # write the header
                writer.writerow(header)

        data = pd.read_csv(filename)
        pdict = req.get("http://127.0.0.1:5000/users?username=" + username)
        pdict = pdict.json()

        new = {
            'username' : [username],
            'percentage' : [pdict['profitpercent']]
        }

        new_data = pd.DataFrame(new)
        # add the newly provided values
        data = data.append(new_data, ignore_index=True)
        # save back to CSV
        d = data.to_dict()
        data.to_csv(filename, index=False)
        return d, 200

    def get(self):
        parser = reqparse.RequestParser()  # initialize
        parser.add_argument('group', location='args', required=True)
        args = parser.parse_args()  # parse arguments to dictionary

        try:
           fn=open(args['group'] + '.csv',"U")
        except IOError:
            return {
                'message': f"'{args['group']}' not found."
            }, 404

        data = pd.read_csv(args['group'] + '.csv')
        for row in data.iterrows():
            pdict = req.get("http://127.0.0.1:5000/users?username=" + row[1][0])
            pdict = pdict.json()
            print(pdict)
            row[1][1] = float(pdict['profitpercent'])

        data = data.sort_values(by=['percentage'], ascending = False)

        print(data)

        d = data.to_dict()
        return d, 200

api.add_resource(Users, '/users')  # '/users' is our entry point
api.add_resource(Messages, '/messages')
api.add_resource(Groups, '/groups')

def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # aapl = Purchase(12/13/2021, 'aapl', 175.74, 1)
    # print(aapl.gain)
    app.run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
