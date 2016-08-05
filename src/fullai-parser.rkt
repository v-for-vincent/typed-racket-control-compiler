; MIT License
;
; Copyright (c) 2016 Vincent Nys
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

#lang brag
fullai-program : (fullai-rule-with-body | fullai-rule-without-body)*
fullai-rule-with-body : abstract-atom-with-args LEADS-TO substitution PERIOD
fullai-rule-without-body : abstract-atom-with-args PERIOD
abstract-atom-with-args : SYMBOL OPEN-PAREN abstract-term (COMMA abstract-term)* CLOSE-PAREN
abstract-term : abstract-variable | abstract-function-term | abstract-lplist
abstract-variable : abstract-variable-a | abstract-variable-g
abstract-variable-a : AVAR-SYMBOL-A NUMBER
abstract-variable-g : AVAR-SYMBOL-G NUMBER
abstract-function-term : (SYMBOL [OPEN-PAREN abstract-term (COMMA abstract-term)* CLOSE-PAREN]) | number-term
number-term : NUMBER
abstract-lplist : OPEN-LIST-PAREN [abstract-term (COMMA abstract-term)* [LIST-SEPARATOR (abstract-lplist | abstract-variable)]] CLOSE-LIST-PAREN
substitution : substitution-pair (COMMA substitution-pair)*
substitution-pair : abstract-variable SLASH abstract-term