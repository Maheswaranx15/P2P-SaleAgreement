// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract AttendanceManagement {
    address public classAdvisor;
    address public classRepresentative;

    mapping(address => bool) public isAuthorized;

    mapping(address => mapping(uint => bool)) public attendance;

    event AttendanceMarked(address indexed student, uint indexed date);

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "You are not authorized to mark attendance");
        _;
    }


    modifier onlyClassAdvisorOrRepresentative() {
        require(msg.sender == classAdvisor || msg.sender == classRepresentative, "You are not the class advisor or class representative");
        _;
    }


    constructor(address _classAdvisor, address _classRepresentative) {
        classAdvisor = _classAdvisor;
        classRepresentative = _classRepresentative;
        isAuthorized[_classAdvisor] = true;
        isAuthorized[_classRepresentative] = true;
    }

    function authorize(address _user) public onlyClassAdvisorOrRepresentative {
        isAuthorized[_user] = true;
    }

    function revokeAuthorization(address _user) public onlyClassAdvisorOrRepresentative {
        isAuthorized[_user] = false;
    }

    function markAttendance(address _student, uint _date) public onlyAuthorized {
        attendance[_student][_date] = true;
        emit AttendanceMarked(_student, _date);
    }

    function viewAttendance(address _student, uint _date) public view returns (bool) {
        return attendance[_student][_date];
    }
}
