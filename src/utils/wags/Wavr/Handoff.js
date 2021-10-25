exports.primePump = function (context) {
  return function() {
    var constant = context.createConstantSource();
    constant.offset.value = 0.0;
    constant.connect(context.destination);
    constant.start();
  }
}