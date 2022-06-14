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

import { CheckBox, CheckBoxGroup, CheckBoxItem, CheckBoxTheme, CheckBoxStatus } from '@ohos/material-checkbox'

@Entry
@Component
struct Index {
  private checkBoxModel1: CheckBox.Model = new CheckBox.Model(1, "CheckBox Unselected")
  private checkBoxModel2: CheckBox.Model = new CheckBox.Model(2, "CheckBox Selected")
  private checkBoxModel3: CheckBox.Model = new CheckBox.Model(3, "CheckBox Error")
  private checkBoxModel4: CheckBox.Model = new CheckBox.Model(4, "CheckBox Disabled Unselected")
  private checkBoxModel5: CheckBox.Model = new CheckBox.Model(5, "CheckBox Disabled Selected")
  private checkBoxModel6: CheckBox.Model = new CheckBox.Model(6, "CheckBox Filled Unselected")
  private checkBoxModel7: CheckBox.Model = new CheckBox.Model(7, "CheckBox Filled Selected")
  private groupModel: CheckBox.GroupModel = new CheckBox.GroupModel()

  aboutToAppear() {
    this.checkBoxModel2.setChecked(true)

    this.checkBoxModel3.setBoxColor(Color.Red).setCheckColor(Color.Red)

    this.checkBoxModel4.setDisabled(true)

    this.checkBoxModel5.setChecked(true).setDisabled(true)

    this.checkBoxModel6.setCheckBoxTheme(CheckBoxTheme.Filled).setCheckColor(Color.White)

    this.checkBoxModel7.setChecked(true).setCheckBoxTheme(CheckBoxTheme.Filled).setCheckColor(Color.White)

    let items = [
      new CheckBoxItem(1, 'Cheese').setChecked(true),
      new CheckBoxItem(2, 'Lettuce').setChecked(false),
      new CheckBoxItem(3, 'Pickles').setChecked(true)
    ]

    this.groupModel.setTitle("Additions").setItems(items)
  }

  private onCheckChange(id: number, bool: boolean) {
    console.log("onCheckChange:: " + id + " - " + bool)
  }

  private onGroupCheckResult(status: CheckBoxStatus, selectedItems: CheckBoxItem []) {
    console.log("onCheckResult:: " + status + " - " + JSON.stringify(selectedItems))
  }

  build() {
    Column() {

      Text("Outlined Checkboxes")
        .fontSize('24vp')
        .margin({ bottom: '24vp' })

      CheckBox({
        model: this.checkBoxModel1,
        onCheckChange: this.onCheckChange
      })

      CheckBox({
        model: this.checkBoxModel2,
        onCheckChange: this.onCheckChange
      })

      CheckBox({
        model: this.checkBoxModel3,
        onCheckChange: this.onCheckChange
      })

      CheckBox({
        model: this.checkBoxModel4,
        onCheckChange: this.onCheckChange
      })

      CheckBox({
        model: this.checkBoxModel5,
        onCheckChange: this.onCheckChange
      })

      Text("Filled Checkboxes")
        .fontSize('24vp')
        .margin({ top: '24vp', bottom: '24vp' })

      CheckBox({
        model: this.checkBoxModel6,
        onCheckChange: this.onCheckChange
      })

      CheckBox({
        model: this.checkBoxModel7,
        onCheckChange: this.onCheckChange
      })

      Text("Checkbox Group")
        .fontSize('24vp')
        .margin({ top: '24vp', bottom: '24vp' })

      CheckBoxGroup({
        model: this.groupModel,
        onCheckResult: this.onGroupCheckResult
      })

    }
    .width('100%')
    .padding('24vp')
    .alignItems(HorizontalAlign.Start)
  }
}