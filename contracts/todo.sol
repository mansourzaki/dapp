// SPDX-License-Identifier: GPL-3.0
// pragma experimental ABIEncoderV2;
pragma solidity ^0.8.14;
// Creating a contract
contract Todo{
    
// Defining a structure to
// store a task
struct Task
{
  string task;
  bool isDone;
}
 
mapping(address => Task[]) public users;
      
event TaskCreated(string task);
// Defining function to add  a task
function addTask(string calldata _task) external
{
  users[msg.sender].push(Task({
    task:_task,
    isDone:false
    }));
  emit TaskCreated(_task);
}
 
// Defining a function to get details of a task 
function getTask(uint _taskIndex) external view returns (Task memory)
{
  Task storage task = users[msg.sender][_taskIndex];
  return task;
}
   
// Defining a function to update status of a task
function updateStatus(uint256 _taskIndex,bool _status) external
{
  users[msg.sender][_taskIndex].isDone = _status;
}
   
// Defining a function to delete a task
function deleteTask(uint256 _taskIndex) external
{
  delete users[msg.sender][_taskIndex];
}
   
// Defining a function to get task count.
function getTaskCount() external view returns (uint256)
{
  return users[msg.sender].length;
} 
}