/*
 * Copyright (c) 2022 Application Library Engineering Group.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CheckBoxItem } from './checkBoxItem'
import { CheckBoxTheme } from './checkBoxTheme'
import { CheckBoxStatus } from './checkBoxStatus'

@Component
export struct CheckBoxGroup {
  @State private model: CheckBox.GroupModel = undefined
  private onCheckResult: ((status: CheckBoxStatus, selectedItems: CheckBoxItem []) => void) = null

  aboutToAppear() {
    if (this.model == null || this.model == undefined) return

    this.model.buildModels()
    this.model.updateSelectedIds()
    this.model.updateStatus()
  }

  private postResult() {
    if (this.onCheckResult != null && this.onCheckResult != undefined) {
      this.onCheckResult(this.model.getStatus(), this.model.getSelectedItems())
    }
  }

  private groupCheckClick() {
    this.model.groupCheckChange()
    this.postResult()
  }

  private onCheckChange(id, bool) {
    this.model.checkChange(id, bool)
    this.model.updateStatus()
    this.postResult()
  }

  build() {
    if (this.model != null && this.model != undefined) {
      Column() {
        Row() {
          Stack() {

            Shape()
              .width('24vp')
              .height('24vp')
              .borderRadius('4vp')
              .backgroundColor(this.model.getBoxColor())
              .opacity(this.model.getStatus() != CheckBoxStatus.None ? 1 : .2)
              .visibility(this.model.getCheckBoxTheme() == CheckBoxTheme.Filled ? Visibility.Visible : Visibility.Hidden)

            Line()
              .strokeWidth(2)
              .startPoint([0, 0])
              .endPoint([12, 0])
              .stroke(this.model.getCheckColor())
              .visibility(this.model.getStatus() == CheckBoxStatus.Partial ? Visibility.Visible : Visibility.Hidden)

            Path()
              .scale({ x: 1.6, y: 1.6 })
              .fill(this.model.getCheckColor())
              .commands("M9 22l-10-10.598 2.798-2.859 7.149 7.473 13.144-14.016 2.909 2.806z")
              .visibility(this.model.getStatus() == CheckBoxStatus.All ? Visibility.Visible : Visibility.Hidden)

          }
          .width('24vp')
          .height('24vp')
          .margin('4vp')
          .borderRadius('4vp')
          .borderColor(this.model.getBoxColor())
          .borderWidth(this.model.getCheckBoxTheme() == CheckBoxTheme.Outlined ? '2vp' : '0vp')

          Flex() {
            Text(this.model.getTitle()).fontSize('16vp')
          }.flexGrow(1).padding('4vp')
        }
        .width('100%')
        .onClick(() => this.groupCheckClick())

        List() {
          ForEach(this.model.getModels(), (item) => {
            ListItem() {
              CheckBox({
                model: item,
                onCheckChange: (id, bool) => {
                  this.onCheckChange(id, bool)
                }
              })
            }
          }, item => item.toString())
        }.margin({ left: 24, top: 8, right: 24 })
      }
    }
  }
}

@Component
export struct CheckBox {
  @State private model: CheckBox.Model = undefined
  private onCheckChange: ((id: number, bool: boolean) => void) = null

  aboutToAppear() {
    if (this.model == null || this.model == undefined) return

    if (this.model.isDisabled()) {
      this.model.setOpacity(0.5)
    }

    if (this.model.isChecked()) {
      this.showCheck()
    } else {
      this.hideCheck()
    }
  }

  private onClick() {
    if (this.model.isDisabled()) return

    this.model.setChecked(!this.model.isChecked())

    if (this.model.isChecked()) {
      this.showCheck()
    } else {
      this.hideCheck()
    }

    if (this.onCheckChange != null && this.onCheckChange != undefined) {
      this.onCheckChange(this.model.getCheckBoxId(), this.model.isChecked())
    }
  }

  private showCheck() {
    animateTo({ duration: 250 }, () => {
      this.model.setInnerScale(1.6)
    })
  }

  private hideCheck() {
    animateTo({ duration: 250 }, () => {
      this.model.setInnerScale(0)
    })
  }

  build() {
    if (this.model != null && this.model != undefined && this.model.buildUI()) {
      Column() {

        Row() {

          Stack() {

            Shape()
              .width('24vp')
              .height('24vp')
              .borderRadius('4vp')
              .opacity(this.model.isChecked() ? 1 : .2)
              .backgroundColor(this.model.getBoxColor())
              .visibility(this.model.getCheckBoxTheme() == CheckBoxTheme.Filled ? Visibility.Visible : Visibility.Hidden)

            Path()
              .fill(this.model.getCheckColor())
              .scale({ x: this.model.getInnerScale(), y: this.model.getInnerScale() })
              .commands("M9 22l-10-10.598 2.798-2.859 7.149 7.473 13.144-14.016 2.909 2.806z")

          }
          .width('24vp')
          .height('24vp')
          .margin('4vp')
          .borderRadius('4vp')
          .opacity(this.model.getOpacity())
          .borderColor(this.model.getBoxColor())
          .borderWidth(this.model.getCheckBoxTheme() == CheckBoxTheme.Outlined ? '2vp' : '0vp')

          Flex() {
            Text(this.model.getCheckBoxLabel()).fontSize('16vp')
          }
          .flexGrow(1)
          .padding('4vp')

        }

      }
      .margin('4vp')
      .onClick(() => this.onClick())
    }
  }
}

export namespace CheckBox {

  class Properties {
    private opacity: number = 1
    private innerScale: number = 0
    private disabled: boolean = false
    private boxColor: string | ResourceColor | Color = Color.Blue
    private checkColor: string | ResourceColor | Color = Color.Blue
    private checkBoxTheme: CheckBoxTheme = CheckBoxTheme.Outlined

    isDisabled(): boolean {
      return this.disabled
    }

    setDisabled(bool: boolean): Properties {
      this.disabled = (bool != null && bool != undefined) ? bool : false;
      return this
    }

    getOpacity(): number {
      return this.opacity
    }

    setOpacity(opacity: number): Properties {
      if (opacity != null && opacity != undefined && (opacity >= 0.5 && opacity <= 1)) {
        this.opacity = opacity;
      } else {
        this.opacity = 1;
      }
      return this
    }

    getInnerScale(): number {
      return this.innerScale
    }

    setInnerScale(scale: number): Properties {
      if (scale != null && scale != undefined && scale <= 1.6) {
        this.innerScale = scale;
      } else {
        this.innerScale = 0;
      }
      return this
    }

    getBoxColor(): string | ResourceColor | Color {
      return this.boxColor
    }

    setBoxColor(color: string | ResourceColor | Color): Properties {
      this.boxColor = (color != null && color != undefined) ? color : Color.Blue;
      return this
    }

    getCheckColor(): string | ResourceColor | Color {
      return this.checkColor
    }

    setCheckColor(color: string | ResourceColor | Color): Properties {
      this.checkColor = (color != null && color != undefined) ? color : Color.Blue;
      return this
    }

    getCheckBoxTheme(): CheckBoxTheme {
      return this.checkBoxTheme;
    }

    setCheckBoxTheme(theme: CheckBoxTheme): Properties {
      this.checkBoxTheme = (theme != null && theme != undefined) ? theme : CheckBoxTheme.Outlined;
      return this
    }

    reset() {
      this.disabled = false

      this.boxColor = Color.Blue
      this.checkColor = Color.Blue

      this.opacity = 1
      this.innerScale = 0

      this.checkBoxTheme = CheckBoxTheme.Outlined
    }
  }

  export class Model extends Properties {
    private checkBoxId: number = undefined
    private checkBoxLabel: string | Resource = undefined

    private checked: boolean = false

    constructor(id: number, label: string | Resource) {
      super()
      this.checkBoxId = id
      this.checkBoxLabel = label
    }

    buildUI(): boolean {
      return (this.checkBoxId != null && this.checkBoxId != -1) &&
      (this.checkBoxLabel != null && this.checkBoxLabel != "")
    }

    getCheckBoxId(): number {
      return this.checkBoxId
    }

    getCheckBoxLabel(): string | Resource {
      return this.checkBoxLabel
    }

    isChecked(): boolean {
      return this.checked
    }

    setChecked(bool: boolean): Model {
      this.checked = (bool != null && bool != undefined) ? bool : false;
      return this
    }

    toString(): string {
      return this.checkBoxId + "" + this.checkBoxLabel + this.checked
    }
  }

  export class GroupModel extends Properties {
    private title: string | Resource = ""

    private status: CheckBoxStatus = CheckBoxStatus.None

    private selectedIds: number [] = []

    private items: CheckBoxItem [] = []

    private models: Model [] = []

    getTitle(): string | Resource {
      return this.title
    }

    setTitle(title: string | Resource): GroupModel {
      this.title = title
      return this
    }

    getStatus(): CheckBoxStatus {
      return this.status
    }

    setStatus(status: CheckBoxStatus): GroupModel {
      this.status = status
      return this
    }

    getModelsLength(): number {
      return this.models.length
    }

    getModels(): Model [] {
      return this.models
    }

    setModels(list: Model []): GroupModel {
      this.models = list
      return this
    }

    setItems(items: CheckBoxItem []): GroupModel {
      this.items = (items != null && items != undefined) ? items : []
      return this
    }

    buildModels() {
      let list = []
      for (var i = 0; i < this.items.length; i++) {
        let item = this.items[i]
        let model = new Model(item.getId(), item.getLabel())
          .setChecked(item.isChecked())
          .setDisabled(this.isDisabled())
          .setOpacity(this.getOpacity())
          .setInnerScale(this.getInnerScale())
          .setBoxColor(this.getBoxColor())
          .setCheckColor(this.getCheckColor())
          .setCheckBoxTheme(this.getCheckBoxTheme())
        list.push(model)
      }
      this.models = list
    }

    updateStatus() {
      if (this.selectedIds.length == this.models.length) {
        this.status = CheckBoxStatus.All
      } else if (this.selectedIds.length > 0) {
        this.status = CheckBoxStatus.Partial
      } else {
        this.status = CheckBoxStatus.None
      }
    }

    updateSelectedIds() {
      this.selectedIds = []
      for (var i = 0; i < this.models.length; i++) {
        let model = this.models[i]
        if (model.isChecked()) {
          this.selectedIds.push(model.getCheckBoxId())
        }
      }
    }

    getSelectedIds(): number [] {
      let list = []
      for (var i = 0; i < this.models.length; i++) {
        let model = this.models[i]
        if (model.isChecked()) {
          list.push(model.getCheckBoxId())
        }
      }
      return list
    }

    getSelectedItems(): CheckBoxItem [] {
      let list = []
      for (var i = 0; i < this.models.length; i++) {
        let model = this.models[i]
        if (model.isChecked()) {
          list.push(new CheckBoxItem(model.getCheckBoxId(), model.getCheckBoxLabel()))
        }
      }
      return list
    }

    groupCheckChange() {
      let selectAll = false

      if (this.status == CheckBoxStatus.None || this.status == CheckBoxStatus.Partial) {
        selectAll = true
        this.status = CheckBoxStatus.All
      } else {
        this.status = CheckBoxStatus.None
      }

      let list = []
      this.selectedIds = []

      for (let i = 0; i < this.models.length; i++) {
        let opt = this.models[i]
        opt.setChecked(selectAll)
        list.push(opt)
        if (selectAll) {
          this.selectedIds.push(opt.getCheckBoxId())
        }
      }

      this.models = list
    }

    checkChange(id, bool) {
      let list = []
      for (var i = 0; i < this.models.length; i++) {
        let opt = this.models[i]
        if (opt.getCheckBoxId() == id) {
          opt.setChecked(bool)
        }
        list.push(opt)
      }
      this.models = list

      if (bool) {
        this.selectedIds.push(id)
      } else {
        const index = this.selectedIds.indexOf(id, 0);
        if (index > -1) {
          this.selectedIds.splice(index, 1);
        }
      }
    }
  }
}

export { CheckBoxItem } from './checkBoxItem'

export { CheckBoxTheme } from './checkBoxTheme'

export { CheckBoxStatus } from './checkBoxStatus'
