/*-----执行文件操作注入，文件系统的基本操作-----*/
window.requestFileSystem = window.requestFileSystem || window.webkitRequestFileSystem; //文件系统请求标识

/*-----文件夹系统的工厂业务-----*/

function DSDataFactory(size, type) {
    var ds = this;
    var fs;

    this.size = size || 1024 * 1024;
    this.type = type || window.TEMPORARY;

    this.fs = fs;

    function errorHandler(e) {
        var msg = '';

        switch (e.code) {
            case FileError.QUOTA_EXCEEDED_ERR: msg = 'QUOTA_EXCEEDED_ERR'; break;
            case FileError.NOT_FOUND_ERR: msg = 'NOT_FOUND_ERR'; break;
            case FileError.SECURITY_ERR: msg = 'SECURITY_ERR'; break;
            case FileError.INVALID_MODIFICATION_ERR: msg = 'INVALID_MODIFICATION_ERR'; break;
            case FileError.INVALID_STATE_ERR: msg = 'INVALID_STATE_ERR'; break;
            default:msg = 'Unknown Error'; break;
        };

        log.debug('Error: ' + msg);
    }

    window.requestFileSystem(this.type, this.size, function (f) {
        fs = f;
        ds.fs = fs;
    }, errorHandler);


    /*--创建一个文件夹--*/
    this.createDirectory = function (directoryName, callback) {
        fs.root.getDirectory(directory, { create: true }, function (dirEntry) {
            //log.debug(directoryName + "目录创建成功！");
            if (callback) callback(directoryName);
        }, errorHandler);
    }
    /*--创建一个文件夹--*/


    /*--移除文件夹内容--*/
    this.removeDirectory = function (directoryName, callback) {
        fs.root.getDirectory(directoryName, {}, function (dirEntry) {
            dirEntry.remove(function () {
                //log.debug(directoryName + "目录成功删除！");
                if (callback) callback(directoryName);
            }, errorHandler);
        }, errorHandler);
    }
    /*--移除文件夹内容--*/

    /*--递归地移除文件夹内容--*/
    this.removeDirectoryAll = function (directoryName, callback) {
        fs.root.getDirectory(directoryName, {}, function (dirEntry) {
            dirEntry.removeRecursively(function () {
                //log.debug(directoryName + "目录及子目录成功删除！");
                if (callback) callback(directoryName);
            }, errorHandler);

        }, errorHandler);
    }
    /*--递归地移除文件夹内容--*/
}

/*-----文件夹系统的工厂业务-----*/


/*-----文件系统的工厂业务(begin)-----*/
function FSDataFactory(size, type) {
    var ds = new DSDataFactory(size, type);
    var fs;

    this.size = size || 1024 * 1024;
    this.type = type || window.TEMPORARY;
    this.ds = ds;
    this.errorHandler = errorHandler;

    function errorHandler(e) {
        var msg = '';
        switch (e.code) {
            case FileError.QUOTA_EXCEEDED_ERR:msg = 'QUOTA_EXCEEDED_ERR'; break;
            case FileError.NOT_FOUND_ERR: msg = 'NOT_FOUND_ERR'; break;
            case FileError.SECURITY_ERR: msg = 'SECURITY_ERR'; break;
            case FileError.INVALID_MODIFICATION_ERR: msg = 'INVALID_MODIFICATION_ERR'; break;
            case FileError.INVALID_STATE_ERR: msg = 'INVALID_STATE_ERR'; break;
            default: msg = 'Unknown Error'; break;
        };
        log.debug('Error: ' + msg);
    }
    window.requestFileSystem(this.type, this.size, function (f) {
        fs = f;
    }, errorHandler);

    /*--读取文件列表--*/
    this.readFileList = function (callback) {
        var dirReader = fs.root.createReader();
        dirReader.readEntries(function (entries) {
            if (callback) callback(entries);
        }, errorHandler);
    }
    /*--读取文件列表--*/



    /*--创建文件--*/
    this.createFile = function (fileName, callback) {
        //Log.debug("createFile  " + fileName);
        fs.root.getFile(fileName, { create: true, exclusive: false }, function (fileEntry) {
            //这边 create 为 true 则说明为创建文件，不存在则创建，存在则报错，因为这边设置了文件是独一的：exclusive: true               
            if (callback) callback(fileEntry.fullPath);
        }, errorHandler);
    }
    /*--创建文件--*/

    /*--逐级创建创建文件和文件夹--*/
    this.createFileWithPath = function (fileName, callback) {
        var paths = fileName.split('/');
        createDir(fs.root, paths);
        function createDir(rootDirEntry, folders) {
            // Throw out './' or '/' and move on to prevent something like '/foo/.//bar'.
            if (folders[0] == '.' || folders[0] == '') {
                folders = folders.slice(1);
            }
            //Log.debug("createDir " + folders[0]);
            if (folders.length == 1 && folders[0].split('.').length > 1) {
                rootDirEntry.getFile(folders[0], { create: true, exclusive: false }, function (fileEntry) {
                    //Log.debug("create file  " + fileEntry.fullPath);
                    if (callback) callback(fileEntry);
                }, errorHandler);
            }
            else {
                rootDirEntry.getDirectory(folders[0], { create: true, exclusive: false }, function (dirEntry) {
                    // Recursively add the new subfolder (if we still have another to create).
                    if (folders.length) {
                        createDir(dirEntry, folders.slice(1));
                    }
                }, errorHandler);
            }
        };
    }
    /*--逐级创建创建文件和文件夹--*/

    /*--逐级创建并写入文件--*/
    this.writeFile = function (fileName, content, callback) {
        fs.root.getFile(fileName, {}, function (fileEntry) {
            fileEntry.remove(function () { 
              writeNewFile(fileName, content, callback);
            });
        }, function () {
            writeNewFile(fileName, content, callback);
        });
    }

    /*--逐级创建创建文件并写入--*/
    function writeNewFile(fileName, content, callback) {
        fsDataFactory.createFileWithPath(fileName, function (fileEntry) {
           // Log.debug("write file  " + fileEntry.fullPath);

            fileEntry.createWriter(function (fileWriter) {
                fileWriter.onwriteend = function (e) {
                    //log.debug(fileName + '写入成功！');
                    if (callback) callback(fileEntry.fullPath);
                };

                fileWriter.onerror = function (e) {
                    //log.error(fileName + '写入错误: ' + e.toString());
                    if (callback) callback(fileEntry.fullPath, e);
                };

                // 创建一个 Blob 并写入文件.
                var bb = new window.WebKitBlobBuilder(); // Note: window.WebKitBlobBuilder in Chrome 12.
                bb.append(content);
                fileWriter.write(bb.getBlob('text/plain'));
            }, errorHandler);
        });
    }

    /*--根据文件名(即文件路径)读取文件--*/
    this.readFileByName = function (fileName, callback) {
        fs.root.getFile(fileName, {}, function (fileEntry) {
            log.debug("File Address:"+fileEntry.toURL());
            fileEntry.file(function (file) {
                var reader = new FileReader();

                reader.onloadend = function (e) {
                    if (callback) callback(this.result);
                };

                reader.readAsText(file);
            }, errorHandler);
        }, function (e) {
            if (callback) callback("0");//为0代表这个文件不存在
        });
    }
    /*--根据文件名读取文件--*/

    this.getFile = function (fileName, callback) {
        fs.root.getFile(fileName, {}, function (fileEntry) {
            fileEntry.file(function (file) {
                if (callback) callback(file);
            }, errorHandler);
        });
    }

    /*--将内容追加进文件--*/
    this.appendFile = function (fileName, content, callback) {
        fs.root.getFile(fileName, { create: false }, function (fileEntry) {
            // 读取一个已经存在的文件，并使用CreateWriter追加数据
            fileEntry.createWriter(function (fileWriter) {
                fileWriter.seek(fileWriter.length);

                var bb = new BlobBuilder();
                bb.append(fileContent);
                fileWriter.write(bb.getBlob('text/plain'));

                if (callback) callback(fileName);
            }, errorHandler);
        }, errorHandler);
    }
    /*--将内容追加进文件--*/


    /*--根据文件名删除文件--*/
    this.deleteFile = function (fileName, callback) {
        fs.root.getFile(fileName, { create: false }, function (fileEntry) {
            fileEntry.remove(function () {
                //log.debug(fileName + '文件删除成功.');
                if (callback) callback(fileName);
            }, errorHandler);
        }, errorHandler);
    }
    /*--根据文件名删除文件--*/

    /*--删除所有文件系统的文件--*/
    this.deleteAll = function (callback) {
        var dirReader = fs.root.createReader();
        dirReader.readEntries(function (entries) {
            for (var i = 0, entry; entry = entries[i]; ++i) {
                if (entry.isDirectory) {
                    entry.removeRecursively(function () { }, errorHandler);
                } else {
                    entry.remove(function () { }, errorHandler);
                }
            }
            //log.debug('Directory emptied.');
            if (callback) callback();
        }, errorHandler);
    }
    /*--删除所有文件系统的文件--*/

    this.listAll = function (dir) {
        if (!dir) {
            listAll(fs.root);
        }
        else if (typeof (dir) == "string") {
            fs.root.getDirectory(dir, function (dirEntry) {
                listAll(dirEntry);
            });
        }
        else {
            var dirReader = dir.createReader();
            dirReader.readEntries(function (entries) {
                for (var i = 0, entry; entry = entries[i]; ++i) {
                    if (entry.isDirectory) {
                        //log.debug("目录：" + entry.fullPath);
                        listAll(entry);
                    } else {
                        //log.debug("文件：" + entry.fullPath);
                    }
                }
            }, errorHandler);
        }
    }
}
/*-----文件系统的工厂业务end-----*/


/*-------实例化-------*/
var dsDataFactory = new DSDataFactory();
var fsDataFactory = new FSDataFactory();
/*-------实例化-------*/
