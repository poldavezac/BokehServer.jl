(function(root, factory) {
    factory(root["Bokeh"]);
})(this, function(Bokeh) {
  let define;
  return (function outer(modules, entry) {
  if (Bokeh != null) {
    return Bokeh.register_plugin(modules, entry);
  } else {
    throw new Error("Cannot find Bokeh. You have to load it prior to loading plugins.");
  }
})({
  "custom/main": function(require, module, exports) {
    const models = {
      "Custom": require("custom/anonymous_Custom").Custom
    };
    require("base").register_models(models);
    module.exports = models;
  },
  "custom/anonymous_Custom": function(require, module, exports) {
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const custom_1 = require("e549ffba6c3d1c6c8a760056b3c4d8892c425857c6e69022a816b3d4d3e473f6");
`${custom_1.CustomView} ${custom_1.Custom}`;
//# sourceMappingURL=custom.js.map"
},
"e549ffba6c3d1c6c8a760056b3c4d8892c425857c6e69022a816b3d4d3e473f6": function(require, module, exports) {
"use strict";
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
exports.Custom = exports.CustomView = void 0;
const ui_element_1 = require("models/ui/ui_element");
const slider_1 = require("models/widgets/slider");
const dom_1 = require("core/dom");
class CustomView extends ui_element_1.UIElementView {
    connect_signals() {
        super.connect_signals();
        this.connect(this.model.slider.change, () => {
            this.render();
        });
    }
    render() {
        super.render();
        this.shadow_el.appendChild((0, dom_1.div)({
            style: {
                padding: '2px',
                color: '#b88d8e',
                backgroundColor: '#2a3153',
            },
        }, `${this.model.text}: ${this.model.slider.value}`));
    }
}
exports.CustomView = CustomView;
CustomView.__name__ = "CustomView";
class Custom extends ui_element_1.UIElement {
}
exports.Custom = Custom;
_a = Custom;
Custom.__name__ = "Custom";
(() => {
    _a.prototype.default_view = CustomView;
    _a.define(({ String, Ref }) => ({
        text: [String, "Custom text"],
        slider: [Ref(slider_1.Slider)],
    }));
})();
//# sourceMappingURL=custom.js.map"
}
}, "custom/main");;
});