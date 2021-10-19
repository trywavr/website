var exec = require("child_process").exec;
// TODO - make this condition better
exec("yum update", function(err) {
  if (err) {
    console.error(err);
    console.log("completed without invoking yum");
  } else {
   /**
    *  exec("ln -s /lib64/libncurses.so.6 /lib64/libtinfo.so.5", function(err) {
      if (err) {
        console.error(err);
      }
      console.log("completed without copying ncurses");
    });
    */
  }
});