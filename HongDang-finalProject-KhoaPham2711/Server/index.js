// express
const express = require('express');
const app = express();

// socket.io
const server = require('http').Server(app);
const io = require('socket.io')(server);

//MD5
var md5 = require('md5');
//body
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended : false}));
//pg
const { Pool, Client } = require('pg');
var pool = new Pool();
pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err) // your callback here
    process.exit(-1)
  })
function connectPool(){
    pool = new Pool({
        user: 'postgres',
        host: 'localhost',
        database: 'Restaurant',
        password: 'root',
        port: 5432,
      })
}

//jwt
const jwt = require('jsonwebtoken')
const secret = 'ios'

//route







//get
app.get('/', function(req,res){
    

});
app.get('/get/category',function(req,res){
    connectPool();
    const qr = `select * from "Category"`
   pool.query(qr, (err, result) => {
        var message = "category"
        res.json({result:true, data: result.rows, message});
        
    });
    pool.end();
});
app.get('/get/menu',function(req,res){
    connectPool();
    const qr = `SELECT "M"."ID", "M"."NAME", "M"."PRICE","M"."STATE","C"."ID" as "IDCATE","C"."Name" as "Category"  FROM "Menu" as "M", "Category" as "C" where "M"."IDCATEGORY" = "C"."ID" `
    pool.query(qr, (err, result) => {
        var message = "menu"
        res.json({result:true, data: result.rows, message});
        
    });
    pool.end();
});
app.get('/get/lobby', function(req,res){
    connectPool();
    const qr = `select * from "Lobby"`
    pool.query(qr, (err, result) => {
        var message = "mang lobby"
        res.json({result:true, data: result.rows, message});
        
      });
      pool.end();
});
app.get('/get/order', function(req,res){
    connectPool();
    const qr = `select * from "ListOrder" where "STATE" = true order by "ID"`
    pool.query(qr, (err, result) => {
        var message = "mang order"
        res.json({result:true, data: result.rows, message});
      });
      pool.end();
});
app.post('/get/table', function(req,res){
    const idlooby = req.body.idlooby
    connectPool();
    const qr = `select * from "Table" where "IDLOBBY" = ${idlooby} order by "ID"`
    pool.query(qr, (err, result) => {
        var message = "thanh cong"
        res.json({result:true, data: result.rows, message});
        
      });
      pool.end();
});
app.get('/get/freetable', function(req,res){
    connectPool();
    const qr = `select * from "Table" where "STATE" = 1 order by "ID"`
    pool.query(qr, (err, result) => {
        var message = "thanh cong"
        res.json({result:true, data: result.rows, message});
      });
      pool.end();
});
app.get('/get/employee', function(req,res){

    connectPool();
    const qr = `select * from "Employee" `
    pool.query(qr, (err, result) => {
        res.json(result.rows);
        
      });
      pool.end();
});
app.get('/get/reservation', function(req,res){

    connectPool();
    const qr = `select * from "Reservation" where "STATE" = true`
    pool.query(qr, (err, result) => {
        var message = "thanh cong"
        res.json({result:true, data: result.rows, message});
        
      });
      pool.end();
});

// post
app.post('/post/billdetail', function(req,res){
    const idBill = req.body.idb
    connectPool();
    const qr = `select "Bill"."ID","Bill"."IDTABLE","ListOrder"."NAME","ListOrder"."QUANTITY","Menu"."PRICE" from "Bill","ListOrder","Menu" 
    where "Bill"."STATE" = true and "Bill"."ID" = "ListOrder"."IDBILL" and "ListOrder"."IDFOOD" = "Menu"."ID" and "Bill"."ID" = ${idBill}`   
    pool.query(qr, (err, result) => {
        var message = "thanh cong"
        res.json({result:true, data: result.rows, message});
        
        
      });
      pool.end().then();
});


app.get('/get/bill', function(req,res){

    connectPool();
    const qr = `select * from "Bill" where  "STATE" = true`
    pool.query(qr, (err, result) => {
        var message = "thanh cong"
        res.json({result:true, data: result.rows, message});
        
      });
      pool.end();
});











//login
//khoi tao token
app.post('/employ/login',function(req,res){
    const email = req.body.email;
    const password = md5(req.body.password);
    connectPool();
    const qr = `select * from "Employee" where "EMAIL" = '${email}' and "PASSWORD" = '${password}'`
    pool.query(qr, (err, result) => {
        var message= "";
        if (result.rowCount === 0) {
            res.json({result:false,token:'',data: [], message});
        } else {
            message = "dang nhap thanh cong";
            var token = jwt.sign({
                email : email,
                pass: password
            },secret,{expiresIn:600}); // thoi han token ton tai trong 600 giay
            res.json({result:true,token:token, data: result.rows, message});
        }
        
        pool.end();
      });
    
})
//kiem tra token va lay du lieu tu token
app.post('/employ/check',function(req,res){
    const token = req.body.token
    if (token){jwt.verify(token,secret,function(err,decoded){
        if (err) {
            return res.json({
                result: false,
                message: ' chua xac thuc',
                data:null,
                token:token
            });
        } else {
            req.decoded = decoded;
            var email = decoded.email
            var password = decoded.pass
            const qr = `select * from "Employee" where "EMAIL" = '${email}' and "PASSWORD" = '${password}'`
            connectPool();
            pool.query(qr, (err, result) => {
                var message = " xac thuc"
                res.json({result:true,token:token, data: result.rows, message});
                pool.end();
            });
        }
    })} else{

    }
})


















//socketio
var today = new Date(); 
io.on('connection',(socket) => {
    socket.on('sendOrder',function(data){
    today = new Date(); 
    var idBill;
    const qrBill = `select "ID" from "Bill" where "IDTABLE" = ${data[0].idTable} and "STATE" = true`
    const qrCreateBill = `insert into "Bill" ("IDTABLE","STATE") values (${data[0].idTable},true)`
    var pool3 = new Pool({
        user: 'postgres',
        host: 'localhost',
        database: 'Restaurant',
        password: 'root',
        port: 5432,
      })
            pool3.query(qrBill, (err, result) => {
                
                if (result.rowCount === 0) {
                    var pool2 = new Pool({
                        user: 'postgres',
                        host: 'localhost',
                        database: 'Restaurant',
                        password: 'root',
                        port: 5432,
                      })
                    pool2.query(qrCreateBill, (err, result) => {
                        var pool1 = new Pool({
                            user: 'postgres',
                            host: 'localhost',
                            database: 'Restaurant',
                            password: 'root',
                            port: 5432,
                          })
                          pool1.query(qrBill, (err, result) => {
                            pool1.end()
                            pool2.end()
                            idBill = result.rows[0].ID
                            data.forEach( async function(order) {
                            connectPool()
                            const qr = `insert into "ListOrder" ("IDTABLE","IDFOOD","NAME","QUANTITY","STATE","DAY","MONTH","YEAR","HOUR","MINUTE","SECONDS","IDBILL","SERVING") 
                            values (${order.idTable},${order.idFood},'${order.name}',${order.quantity},true,
                                ${today.getDate()},${today.getMonth()+1},${today.getFullYear()},${today.getHours()},${today.getMinutes()},${today.getSeconds()},${idBill},false)`
                            pool.query(qr, (err, result) => {
                                
                            });
                            pool.end().then()
                        });
                          })
                        
                        
                    })
                }
                else{
                    
                    idBill = result.rows[0].ID
                    data.forEach(async function(order) {
                        connectPool()
                        const qr = `insert into "ListOrder" ("IDTABLE","IDFOOD","NAME","QUANTITY","STATE","DAY","MONTH","YEAR","HOUR","MINUTE","SECONDS","IDBILL","SERVING") 
                        values (${order.idTable},${order.idFood},'${order.name}',${order.quantity},true,
                        ${today.getDate()},${today.getMonth()+1},${today.getFullYear()},${today.getHours()},${today.getMinutes()},${today.getSeconds()},${idBill},false)`
                        pool.query(qr, (err, result) => {});
                        pool.end().then()
                    });
            }
        })
    pool3.end().then();
    // io.emit('refreshOrder', "true"); 
        
    });
    socket.on('changeStateTable',function(data){
        connectPool();
            const qr = `update "Table" set "STATE" = '3' where "ID" = ${data}`
            pool.query(qr, (err, result) => {
                io.emit('refreshTable', "true"); 
                io.emit('refreshOrder', "true");
                io.emit('refreshPayment', "true");
            });
            pool.end();
    })
    socket.on('changeStateServing',function(data){
        connectPool();
            const qr = `update "ListOrder" set "SERVING" = true where "IDTABLE" = ${data.IDTABLE}`
            const qrState = `update "ListOrder" set "STATE" = false where "ID" = ${data.ID}`
            pool.query(qr, (err, result) => {
                var pool1 = new Pool({
                    user: 'postgres',
                    host: 'localhost',
                    database: 'Restaurant',
                    password: 'root',
                    port: 5432,
                  })
                pool1.query(qrState,(err, result) => {
                    io.emit('refreshTable', "true"); 
                    io.emit('refreshOrder', "true");
                    io.emit('refreshPayment', "true");
                })
                pool1.end()
                
            });
            pool.end();
    })

    socket.on('sendReservation',function(data){
        connectPool();
        const qr = `insert into "Reservation" ("NAME","DAY","MONTH","YEAR","HOUR","MINUTE","STATE","IDTABLE","INTIME")
        values ('${data.name}',${data.day},${data.month},${data.year},${data.hour},${data.minute},true,-1,false)`;
        console.log(qr)
        pool.query(qr, (err, result) => {
            io.emit('refreshReservation', "true");
        })
        pool.end().then()
    })

    socket.on('pay',function(data){

        connectPool();
        const qr = `update "Bill" set "STATE" = false where "ID" = ${data.BillID}`;
        const qr2 = `update "Table" set "STATE" = 1 where "ID" = ${data.TableID}`;
        const qr3 = `update "ListOrder" set "STATE" = false where "IDBILL" = ${data.BillID}`;
        const qr4 = `update "Reservation" set "STATE" = false where "IDTABLE" = ${data.TableID} and "STATE" = true`
        pool.query(qr, (err, result) => {
            var pool1 = new Pool({
                user: 'postgres',
                host: 'localhost',
                database: 'Restaurant',
                password: 'root',
                port: 5432,
              })
            pool1.query(qr2, (err, result) => { 
                var pool2 = new Pool({
                    user: 'postgres',
                    host: 'localhost',
                    database: 'Restaurant',
                    password: 'root',
                    port: 5432,
                  })
                pool2.query(qr3, (err, result) => { 
                    var pool3 = new Pool({
                        user: 'postgres',
                        host: 'localhost',
                        database: 'Restaurant',
                        password: 'root',
                        port: 5432,
                      })
                    pool3.query(qr4, (err, result) => { 
                        io.emit('refreshTable', "true"); 
                        io.emit('refreshOrder', "true");
                        io.emit('refreshPayment', "true");
                        io.emit('refreshReservation', "true");
                    })
                    pool3.end().then()
                    
                    
                    
                })
                pool2.end().then()
            })
            pool1.end().then()
        })
        pool.end().then()
    })
    socket.on ('setStateReserved', function(data){
        connectPool();
        const qr = `update "Table" set "STATE" = 2 where "ID" = ${data.idtable}`
        const qr1 = `update "Reservation" set "IDTABLE" = ${data.idtable} where "ID" = ${data.id}`
        console.log(qr)
        pool.query(qr, (err, result) => { 
            var pool1 = new Pool({
                user: 'postgres',
                host: 'localhost',
                database: 'Restaurant',
                password: 'root',
                port: 5432,
              })
            pool1.query(qr1, (err, result) => {
                io.emit('refreshReservation', "true");
                io.emit('refreshTable', "true");
            })
            pool1.end().then();
        })
        
        pool.end().then();
    })
    socket.on ('deleteReserved', function(data){
        connectPool();
        const qr = `update "Table" set "STATE" = 1 where "ID" = ${data}`
        const qr1 = `update "Reservation" set "STATE" = false where "IDTABLE" = ${data} and "STATE" = true`

        pool.query(qr, (err, result) => { 
            var pool1 = new Pool({
                user: 'postgres',
                host: 'localhost',
                database: 'Restaurant',
                password: 'root',
                port: 5432,
              })
            pool1.query(qr1, (err, result) => {
                io.emit('refreshReservation', "true");
                io.emit('refreshTable', "true");
            })
            pool1.end().then();
        })
        pool.end().then()
    })
    socket.on('deleteServing',function(data){

        connectPool();
        const qr = `update "Bill" set "STATE" = false where "IDTABLE" = ${data} and "STATE" = true`;
        const qr2 = `update "Table" set "STATE" = 1 where "ID" = ${data}`;
        const qr3 = `update "ListOrder" set "STATE" = false where "IDTABLE" = ${data} and "STATE" = true`;
        pool.query(qr, (err, result) => {
            var pool1 = new Pool({
                user: 'postgres',
                host: 'localhost',
                database: 'Restaurant',
                password: 'root',
                port: 5432,
              })
            pool1.query(qr2, (err, result) => { 
                var pool2 = new Pool({
                    user: 'postgres',
                    host: 'localhost',
                    database: 'Restaurant',
                    password: 'root',
                    port: 5432,
                  })
                pool2.query(qr3, (err, result) => { 
                    io.emit('refreshTable', "true"); 
                    io.emit('refreshOrder', "true");
                    io.emit('refreshPayment', "true");
                    pool2.end().then()
                    pool1.end().then()
                    pool.end().then()
                })
                
            })
            
        })
    })


    socket.on('setIntime',function(data){
        connectPool();
        const qr = `update "Reservation" set "INTIME" = true where "ID" = ${data} `;
        console.log(qr)
        pool.query(qr,(err, result) => {
            io.emit('refreshReservation', "true");
        })
        pool.end().then()
    })



    var instance1 = Singleton.getInstance();
})
// var time = Singleton.getInstance()
var Singleton = (function () {
    var instance;
 
    function createInstance() {
        var timeLoop = setInterval(function()
        { 
            io.emit('refreshMinute', "true");    
        }, 1000*60);
        return timeLoop;
    }
 
    return {
        getInstance: function () {
            if (!instance) {
                instance = createInstance();
            }
            return instance;
        }
    };
})();

server.listen(3000);


