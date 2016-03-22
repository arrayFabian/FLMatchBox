

/*-------执行SQLite注入,数据库的基本操作(Begin)-------*/
function SQLProvider(dbName, size) {
    this.dbName = dbName || 'OFLMAIL';

    var db = openDatabase(this.dbName, '1.0', 'database for ' + this.dbName, (size || 2) * 1024 * 1024);
    this.db = db;

    /*-------执行SQLite注入,数据库的基本操作(End)-------*/

    function sqlerrorHandler(tx, e) {
        log.error(e.message);
    }

    /*-------执行SQLite的工厂业务,CURD操作(Begin)-------*/

    /*--添加数据表(插入数据)--*/
    this.insertRow = function (tableName, fields, values, callback) {
        var sql = "INSERT INTO " + tableName + " (" + fields.join(",") + ") SELECT "
         + new Array(values.length + 1).join(",?").substr(1);

        db.transaction(function (tx) {
            tx.executeSql(sql, values, function () { }, sqlerrorHandler);
            //log.debug(sql);

            tx.executeSql("SELECT max(" + tableName + "_SEC) id from " + tableName, [], function (tx, result) {
                var item = result.rows.item(0);
                var id = parseInt(item.id);
                //log.debug("id=" + id);
                if (callback) callback(id);
            }, sqlerrorHandler);
        });
    }

    /*--添加数据表--*/
    this.createTable = function (tableName, fields, callBack) {
        var pkField = tableName + "_SEC";
        var sql = "CREATE TABLE IF NOT EXISTS " + tableName + "( " + pkField + " integer primary key autoincrement,";

        // 合并字段串同时去除传入的主键字段
        sql += fields.join(",").replace(pkField + ",", "") + ")";
        //log.debug(sql);

        db.transaction(function (tx) {
            tx.executeSql(sql, [], function () {
                if (callBack) callBack();
            }, sqlerrorHandler);
        })
    }

    /*--删除数据表--*/
    this.dropTable = function (tableName) {
        var sql = "DROP TABLE " + tableName;
        db.transaction(function (tx) {
            tx.executeSql(sql);
        })
    }


    /*--删除数据--*/
    this.deleteRow = function (tableName, sec,callback) {
        var pkField = tableName + "_SEC";
        var sql = "DELETE FROM " + tableName + " WHERE " + pkField + " = ?";
        db.transaction(function (tx) {
            tx.executeSql(sql, [sec], null, sqlerrorHandler);
            if (callback) callback(); //使用回调 
        })
    }

    /*--读取数据表--*/
    this.loadTable = function (tableName, callback) {
        db.transaction(function (tx) {
            tx.executeSql('SELECT * from ' + tableName, [], function (tx, result) {
                if (callback) callback(result); //使用回调                
            }, sqlerrorHandler);
        });
    }

    /*--根据查询条件读取数据表--*/
    this.loadTableBySQl = function (tableName, sqlSenten, callback) {
        db.transaction(function (tx) {
            tx.executeSql('SELECT * from ' + tableName+" WHERE "+ sqlSenten, [], function (tx, result) {
                if (callback) callback(result); //使用回调                
            }, sqlerrorHandler);
        });       
    }

    // 查询记录
    this.select = function (tableName, fields, values, callback) {
        if (!fields || fields.length == 0) {
            return this.loadTable(tableName, callback);
        }

        var sql = 'SELECT * from ' + tableName + " where " + fields.join("=? and ") + "=?";
        //log.debug(sql);

        db.transaction(function (tx) {
            tx.executeSql(sql, values, function (tx, result) {
                if (callback) callback(result); //使用回调                
            }, sqlerrorHandler);
        });
    }

    /*--读取单行数据--*/
    this.readRow = function (tableName, sec, callback) {
        db.transaction(function (tx) {
            tx.executeSql('SELECT * FROM ' + tableName + ' WHERE ' + tableName + '_SEC = ?', [sec], function (tx, result) {
                if (callback) callback(result.rows.item(0)); // 使用回调  
            }, sqlerrorHandler);
        });
    }

    /*--检查是否已存在该列--*/
    this.checkExist = function (tableName, fieldName, fieldValue, callback) {
        db.transaction(function (tx) {
            tx.executeSql('SELECT * from ' + tableName + ' where ' + fieldName + '= ?', [fieldValue], function (tx, result) {
                var isExist;
                if (result.rows.length == 1) isExist = "1"; else isExist = "0"; //1代表存在该行,0 代表不存在该行
                if (callback) callback(isExist);
            }, sqlerrorHandler);
        });
    }

    /*--更新列，这边需要注意的是两个参数列表的首位必须是主键(或者说第一个必须是条件，后面的是修改位)--*/
    this.updateRow = function (tableName, fields, values,callback) {
        var len = fields.length;

        var sql = "";
        for (i = 1; i < len; i++) {
            if (i == 1) sql += fields[i] + " = '" + values[i] + "'";
            else sql += "," + fields[i] + " = '" + values[i] + "'";
        }

        sql = 'UPDATE ' + tableName + ' SET ' + sql + ' where ' + fields[0] + '= ?';
        //log.debug("sql:" + sql);

        db.transaction(function (tx) {
            tx.executeSql(sql, [values[0]],
             null, sqlerrorHandler);
            //log.debug("update " + tableName + " success! sec=" + values[0]);
            if (callback) callback();
        });
    }
}
/*-------执行SQLite的工厂业务,CURD操作(End)-------*/


/*-------实例化-------*/
var sqlProvider = new SQLProvider();
/*-------实例化-------*/