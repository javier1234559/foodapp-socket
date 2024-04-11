const order_lists = []

const fetchOrder = () => {
    fetch('/orders/all')
        .then(response => response.json())
        .then(data => {
            // Get the tbody element where orders will be displayed
            const orderBody = document.getElementById('order-body');

            // Clear existing content
            orderBody.innerHTML = '';
            console.log(data)
            // Iterate over the orders data and create table rows
            
            order_lists
            data.data.forEach(order => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${order.id}</td>
                    <td><span>🎂</span></td>
                    <td><button class="change-status-btn" data-order-id="${order.id}" onclick="updateOrderStatus(${order.id}, '${order.status}')">${order.status}</button></td>
                `;
                orderBody.appendChild(row);
            });
        })
        .catch(error => console.error('Error fetching orders:', error));
}

function updateOrderStatus(orderId, currentStatus) {
    // Define the next status based on the current status
    console.log(orderId)
    console.log(currentStatus)

    let nextStatus;
    switch (currentStatus) {
        case 'Pedding':
            nextStatus = 'Process';
            postDataChange(orderId, nextStatus);
            break;
        case 'Process':
            nextStatus = 'Done';
            postDataChange(orderId, nextStatus);
            break;
        case 'Done':
            deleteData(orderId);
            console.log('delete not run !!')
            // If current status is 'Done', remove the order
            // You can handle removal here or call another function
            return;
        default:
            return;
    }

    // Send POST request to update order status
    function postDataChange(orderId, nextStatus) {
        fetch('/orders/update', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                orderId: orderId,
                status: nextStatus
            })
        })
            .then(response => response.json())
            .then(data => {
                console.log(data.message); // Log the server response message
                // Update the order status displayed on the button
                const button = document.querySelector(`button[data-order-id="${orderId}"]`);
                button.textContent = nextStatus;
                button.setAttribute('onclick', `updateOrderStatus(${orderId}, '${nextStatus}')`);
            })
            .catch(error => console.error('Error updating order status:', error));
    };

    function deleteData(orderId) {
        fetch(`/orders/${orderId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                console.log(data.message); // Log the server response message
                // Update the order status displayed on the button
                const button = document.querySelector(`button[data-order-id="${orderId}"]`);
                button.textContent = "Done";
                button.disabled = true;
            })
            .catch(error => console.error('Error updating order status:', error));
    }
}


fetchOrder();






