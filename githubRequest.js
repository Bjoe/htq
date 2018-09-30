.pragma library

var passwd;
var giturl;

function getGithubJson(command , onDoneCallback)
{
    console.log(giturl + " " + passwd);
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function() {
        if (httpRequest.readyState == XMLHttpRequest.DONE) {
            var text = httpRequest.responseText;
            console.log("Response: => " + text);
            var json = JSON.parse(text);
            onDoneCallback(json);
        }
    }
    httpRequest.open("POST", giturl);
    httpRequest.setRequestHeader("Authorization", "Basic " + passwd);
    httpRequest.setRequestHeader("Accept", "application/json");
    var request = "{ \"query\": \"" + command + "\"}";
    console.log("Request: => " + request)
    httpRequest.send(request);
}

function getGithubRepository(owner, reponame, resultCallback)
{
    var cmd = "query { \
      repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
        projectsUrl \
      } \
    }";

    getGithubJson(cmd, function(json)
    {
        var repo = json.data.repository;
        resultCallback(repo.projectsUrl)
    });
}

function getGithubBranches(owner, reponame, resultCallback)
{
    var cmd = "query { \
      repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
        refs(refPrefix: \\\"refs/heads/\\\", first: 20) { \
          edges { \
            node { \
              name \
            } \
          } \
          pageInfo { \
            endCursor \
            hasNextPage \
          } \
        } \
      } \
    }"

    getGithubJson(cmd, function(json)
    {
        var repo = json.data.repository;
        getNextGithubBranch(owner, reponame, repo.refs.pageInfo.endCursor, repo.refs.pageInfo.hasNextPage, function(result)
        {
            var r = result.concat(repo.refs.edges);
            resultCallback(r);
        });
    });
}

function getNextGithubBranch(owner, reponame, endCursor, hasNextPage, resultCallback)
{
    if(hasNextPage)
    {
        var nextcmd = "query { \
          repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
            refs(refPrefix: \\\"refs/heads/\\\", first: 20, after: \\\"" + endCursor + "\\\") { \
              edges { \
                node { \
                  name \
                } \
              } \
              pageInfo { \
                endCursor \
                hasNextPage \
              } \
            } \
          } \
        }";
        getGithubJson(nextcmd, function(json) {
            var repo = json.data.repository;
            getNextGithubBranch(owner, reponame, repo.refs.pageInfo.endCursor, repo.refs.pageInfo.hasNextPage, function(result)
            {
                var r = result.concat(repo.refs.edges);
                resultCallback(r);
            });
        });
    }
    else
    {
        var a = new Array;
        resultCallback(a);
    }
}

function getGithubCommit(owner, reponame, branch, resultCallback)
{
    var cmd = "query { \
      repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
        ref(qualifiedName: \\\"" + branch + "\\\") { \
            target { \
                oid \
                ... on Commit { \
                    message \
                    zipballUrl \
                } \
            } \
        } \
      } \
    }";

    getGithubJson(cmd, function(json)
    {
        console.log(json);
        var commit = json.data.repository.ref.target;
        resultCallback(commit.oid, commit.message, commit.zipballUrl);
    });
}
