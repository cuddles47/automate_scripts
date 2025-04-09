#!/bin/bash

# Tạo thư mục cho các node
mkdir -p rs0-0 rs0-1 rs0-2

# Khởi động 3 MongoDB instance với các cổng khác nhau
mongod --replSet "rs0" --port 27017 --dbpath rs0-0 --bind_ip localhost --fork --logpath rs0-0/mongod.log
mongod --replSet "rs0" --port 27018 --dbpath rs0-1 --bind_ip localhost --fork --logpath rs0-1/mongod.log
mongod --replSet "rs0" --port 27019 --dbpath rs0-2 --bind_ip localhost --fork --logpath rs0-2/mongod.log

# Đợi các instance khởi động
sleep 5

# Khởi tạo replica set
mongo --port 27017 <<EOF
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "localhost:27017" },
    { _id: 1, host: "localhost:27018" },
    { _id: 2, host: "localhost:27019" }
  ]
})
EOF

echo "Replica Set 'rs0' initiated."
