function next_greater(arr) {
let stack = new Stack()
let result = [-1] * len(arr)
for (let i = len(arr) - 1; i = 0; i--) {
while (!stack.empty() && arr[stack.top()] <= arr[i]) stack.pop()
if (!stack.empty()) result[i] = stack.top()
stack.push(i)
}
return result
}