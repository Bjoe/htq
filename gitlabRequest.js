.pragma library

var privtoken;
var giturl;

function gitlabRequest(command , onDoneCallback) {
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function() {
        if (httpRequest.readyState == XMLHttpRequest.DONE) {
            var text = httpRequest.responseText;
            console.log("Response: " + text);
            var json = JSON.parse(text);
            onDoneCallback(json);
        }
    }
    var u = giturl + "/api/v4/" + command;
    console.log("Request: " + u);
    httpRequest.open("GET", u);
    httpRequest.setRequestHeader("PRIVATE-TOKEN", privtoken);
    httpRequest.send();
}


function getProjects(projectId, resultCallback)
{
    gitlabRequest("projects/" + projectId, resultCallback);
}

function getBranches(projectId, resultCallback)
{
    gitlabRequest("projects/" + projectId + "/repository/branches", resultCallback);
}

function getCommit(projectId, branch, resultCallback)
{
    var encodedBranch = encodeURIComponent(branch);
    gitlabRequest("projects/" + projectId + "/repository/branches/" + encodedBranch, resultCallback)
}
