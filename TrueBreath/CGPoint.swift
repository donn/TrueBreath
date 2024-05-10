/*
Copyright ©2024 Mohamed Gaber

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import Foundation

extension CGPoint {
    func rotate(around center: CGPoint, degrees: Double) -> CGPoint {
        let sine = sin(degrees);
        let cosine = cos(degrees);
        
        let pointTranslated = CGPoint(x: self.x - center.x, y: self.y - center.y)
        
        let newX = pointTranslated.x * cosine - pointTranslated.y * sine;
        let newY = pointTranslated.x * sine - pointTranslated.y * cosine;
        
        return CGPoint(x: newX + center.x, y: newY + center.y)
    }
}
