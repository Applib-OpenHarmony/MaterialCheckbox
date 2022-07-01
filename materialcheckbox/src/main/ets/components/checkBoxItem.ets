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

export class CheckBoxItem {
  private id: number
  private label: string | Resource

  private checked: boolean = false

  constructor(id: number, label: string | Resource) {
    this.id = id
    this.label = label
  }

  getId(): number {
    return this.id
  }

  setId(id: number): CheckBoxItem {
    this.id = id
    return this
  }

  getLabel(): string | Resource {
    return this.label
  }

  setLabel(label: string | Resource): CheckBoxItem {
    this.label = label
    return this
  }

  isChecked(): boolean {
    return this.checked
  }

  setChecked(bool: boolean): CheckBoxItem {
    this.checked = bool != null ? bool : false
    return this
  }

  toString() {
    return this.id + "" + this.label + this.checked
  }
}