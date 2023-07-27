## Database-Design-Code
### 关系：
一个人可以报修多次  **one-to-many**
```
users.id < maintainInfo.uid
```
报修的id和派工表的报修编号一致 **one-to-one** 
```
maintainInfo.id - dispatch.m_id
```
派工表中派工人和用户的id一致  **one-to-one**
```
dispatch.id - users.id
```
维修表中的维修人编号和用户id存在多对多关系  **many-to-many** 
```
Table user_maintain { // many-to-many
  user_id int 
  maintain_uid int 
}
Ref: U.id > user_maintain.user_id
Ref: maintain.uid > user_maintain.
```
维修表的id应该跟报修的id一致 **one-to-one** 
```
maintain.id - maintainInfo.id
```

```
//=======================================
//// -- LEVEL 1
//// -- Tables and References

// Creating tables
Table users as U {
  id int [pk, increment] // auto-increment
  name varchar [not null]
  password varchar [not null]
  status user_status [not null] // 0-student; 1-admin; 2-maintenance staffs
}

Table maintainInfo {
  id int [pk, increment] // auto-increment
  num smallint [not null]
  room smallint [not null]
  content text [not null]
  uid int [ref: > U.id, note:'users.status == 0']
  date datetime [default:'now()']
  phone varchar [not null]
  status maintainInfo_status //0-stored 1-pending 2-allocated 3-finished
 }

Table dispatch {
  id int [pk, increment]
  m_id int [not null]
  u_id int [ ref: - U.id, not null, note:'users.status == 1'] 
}

Table maintain {
  id int [pk, increment, ref: - maintainInfo.id] // primary key
  reason varchar [not null]
  process mediumtext [not null, note: 'When order created']
  result mediumtext [not null]
  uid int [note:'users.status == 2']
}

// Creating references
// You can also define relaionship separately
// > many-to-one; < one-to-many; - one-to-one;
Ref: maintainInfo.id - dispatch.(m_id)
//----------------------------------------------//

//// -- LEVEL 2
//// -- Adding column settings
Table user_maintain { // many-to-many
  user_id int 
  maintain_uid int 
}
Ref: U.id > user_maintain.user_id
Ref: maintain.uid > user_maintain.maintain_uid
// //----------------------------------------------//
// //// -- Level 3 
// //// -- Enum, or Indexes
Enum user_status {
  student [note:'0-student']
  admin [note:'1-admin']
  maintenanceWorker [note:'2-maintenanceWorker']
}

Enum maintainInfo_status {
  stored [note:'0-stored']
  pending [note:'1-pending']
  dispatched [note:'2-dispatched']
  finished [note:'3-finished']
}
```