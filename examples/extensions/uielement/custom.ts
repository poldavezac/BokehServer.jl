import {UIElement, UIElementView} from "models/ui/ui_element"

import {Slider} from "models/widgets/slider"
import {div} from "core/dom"
import * as p from "core/properties"

export class CustomView extends UIElementView {
  override model: Custom

  override connect_signals(): void {
    super.connect_signals()

    this.connect(this.model.slider.change, () => {
      this.render()
    })
  }

  override render(): void {
    super.render()
    this.shadow_el.appendChild(div({
      style: {
        padding: '2px',
        color: '#b88d8e',
        backgroundColor: '#2a3153',
      },
    }, `${this.model.text}: ${this.model.slider.value}`))
  }
}

export namespace Custom {
  export type Attrs = p.AttrsOf<Props>

  export type Props = UIElement.Props & {
    text: p.Property<string>
    slider: p.Property<Slider>
  }
}

export interface Custom extends Custom.Attrs {}

export class Custom extends UIElement {
  override properties: Custom.Props
  static {
    this.prototype.default_view = CustomView

    this.define<Custom.Props>(({String, Ref}) => ({
      text:   [String, "Custom text"],
      slider: [Ref(Slider)],
    }))
  }
}
