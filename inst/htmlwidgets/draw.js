HTMLWidgets.widget({
  name: "draw",

  type: "output",

  //factory: function(el, width, height) {
  factory: function(el, width, height) {

    var map;

    return {
      renderValue: function(x) {
        el.innerText = "";
        if (!x.parameters.params.hasOwnProperty("width")) {
          x.parameters.params.width = width;
        }
        console.log(x);
        map = bertin.draw(x.parameters);
        el.appendChild(map);

        // Hide layers
        if (x.hasOwnProperty("hide_layers")) {
          x.hide_layers.forEach((d) => {
            map.update({
              id: d,
              attr: "visibility",
              value: false,
              duration: 0
            });
          });
        }
      },
      getMap: function() {
        return map;
      },
      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});


function getBertin(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);
  var map;
  if (typeof htmlWidgetsObj != "undefined") {
    map = htmlWidgetsObj.getMap();
  }
  return map;
}

if (HTMLWidgets.shinyMode) {
  Shiny.addCustomMessageHandler("bertin-update", function(message) {
    var map = getBertin(message.id);
    if (typeof map != "undefined") {
      map.update(message.data);
    }
  });
}
