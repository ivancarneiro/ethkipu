// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

contract TaskManager2 {
    //Pending, InProgress, Done
    enum TaskStatus {
        Pending,
        InProgress,
        Done
    }

    struct Task {
        uint256 id;
        string title;
        TaskStatus status;
    }

    Task[] public tasks;
    uint256 public taskCounter;
    uint256 constant MAX_TASK=10;

    modifier maxTask() {
        require(taskCounter<MAX_TASK,"Me pase");
        _;
    }

    bool flag = false;
    modifier guard() {
        require(flag==false,"usted no puede entrar");
        flag=true;
        _;
        flag=false;
    }

    event taskCreated(uint256 indexed id, string title);

    function createTask(string calldata _title) external maxTask {
        uint256 _taskCounter = taskCounter;
        tasks.push(Task(_taskCounter,_title,TaskStatus.Pending));
        emit taskCreated(_taskCounter, _title);
        _taskCounter ++;
        taskCounter = _taskCounter;
    }

    modifier existId(uint256 _id) {
        require(_id<taskCounter,"not exist");
        _;
    }

    function updateStatus(uint256 _id,TaskStatus _status) external existId(_id){
        tasks[_id].status = _status;
    }

    function readFirstPendig() external view returns(Task memory) {
        uint256 Len = tasks.length;
        for(uint256 i=0; i < Len; i++) {
            if(tasks[i].status == TaskStatus.Pending) {
                return tasks[i];
            }
        }
        return tasks[Len-1];
    }


}