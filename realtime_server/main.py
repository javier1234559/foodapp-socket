from flask import Flask, jsonify, Response, request, render_template
from flask_sock import Sock
import json
from threading import Lock


app = Flask(__name__)
sock = Sock(app)

data_products = [
    {
        'id': 1,
        'name': 'Bánh mì',
        'price': 20000,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/B%C3%A1nh_m%C3%AC_th%E1%BB%8Bt_n%C6%B0%E1%BB%9Bng.png/640px-B%C3%A1nh_m%C3%AC_th%E1%BB%8Bt_n%C6%B0%E1%BB%9Bng.png',
    }, {
        'id': 2,
        'name': 'Bún riêu',
        'price': 30000,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Bun_rieu.jpg/250px-Bun_rieu.jpg',
    }, {
        'id': 3,
        'name': 'Phở',
        'price': 40000,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Pho_quay.JPG/250px-Pho_quay.JPG',
    }, {
        'id': 4,
        'name': 'Bún bò',
        'price': 35000,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Bunbo.jpg/250px-Bunbo.jpg',
    }, {
        'id': 5,
        'name': 'Bún chả',
        'price': 35000,
        'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/B%C3%BAn_ch%E1%BA%A3_Th%E1%BB%A5y_Khu%C3%AA.jpg/220px-B%C3%BAn_ch%E1%BA%A3_Th%E1%BB%A5y_Khu%C3%AA.jpg',
    }
]
order_list = []
order_index = 0
order_lock = Lock()


class Order:
    def __init__(self, id, status, name, socket, product_id):
        self.id = id
        self.name = name
        self.product_id = product_id
        self.status = status
        self.socket = socket

    def send(self, message):
        self.socket.send(message)

    def changeStatus(self, status):
        self.status = status

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'product_id': self.product_id,
            'status': self.status,
        }


@app.route('/products')
def products():
    return jsonify(data_products)


@sock.route('/orders/create')
def createOrder(ws):
    global order_index

    order = None  # Initialize order outside the try block

    try:
        while True:
            data = ws.receive()
            message = json.loads(data)

            if message.get('type') == 'Subscribe':
                # Acquire the lock
                with order_lock:
                    order_index += 1
                    current_order_index = order_index

                status = 'Pedding'
                product_name = message.get('name')
                product_id = message.get('product_id')
                order = Order(order_index,
                              status,
                              product_name,
                              ws, product_id)
                order_list.append(order)

                # ws.send(json.dumps({'order_index': current_order_index}))
    finally:
        if order is not None:
            order_list.remove(order)


@app.route('/orders/update', methods=['POST'])
def updateOrder():
    data = request.json
    orderId = data['orderId']
    status = data['status']

    for order in order_list:
        if order.id == orderId:
            order.changeStatus(status)
            order.send(status)
            return jsonify({"message": "update done"})

    return jsonify({"message": "update false"})


@app.route('/orders/<int:orderId>', methods=['DELETE'])
def orderDelete(orderId):
    for order in order_list:
        if order.id == orderId:
            order_list.remove(order)
            return jsonify({"message": "delete done"})

    return jsonify({"message": "not found"})


@app.route('/orders/all', methods=['GET'])
def orderGetAll():
    # global order_list

    return jsonify({
        'data': [order.to_dict() for order in order_list]
    })


@app.route("/")
def home():
    return render_template("home.html")


@app.route("/orders")
def dashboard():
    return render_template("index.html")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)
