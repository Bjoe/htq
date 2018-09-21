.pragma library

function getJson(command , onDoneCallback)
{
    var httpRequest = new XMLHttpRequest();
    httpRequest.onreadystatechange = function() {
        if (httpRequest.readyState == XMLHttpRequest.DONE) {
            var text = httpRequest.responseText;
            console.log("Response: => " + text);
            var json = JSON.parse(text);
            onDoneCallback(json);
        }
    }
    httpRequest.open("POST", "https://api.github.com/graphql");
    httpRequest.setRequestHeader("Authorization", "Basic QmpvZTowMTEwNTM3MTE0YWVlYzE3ZjYwMzcwNTczNzA5NGM0ZjM4ZGI5NGJj");
    httpRequest.setRequestHeader("Accept", "application/json");
    var request = "{ \"query\": \"" + command + "\"}";
    console.log("Request: => " + request)
    httpRequest.send(request);
}

function getRepository(owner, reponame, resultCallback)
{
    var cmd = "query { \
      repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
        projectsUrl \
      } \
    }";

    getJson(cmd, function(json)
    {
        var repo = json.data.repository;
        resultCallback(repo.projectsUrl)
    });
}

function getBranches(owner, reponame, resultCallback)
{
    var cmd = "query { \
      repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
        refs(refPrefix: \\\"refs/heads/\\\", first: 2) { \
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

    getJson(cmd, function(json)
    {
        var repo = json.data.repository;
        getNextBranch(owner, reponame, repo.refs.pageInfo.endCursor, repo.refs.pageInfo.hasNextPage, function(result)
        {
            var r = result.concat(repo.refs.edges);
            resultCallback(r);
        });
    });
}

function getNextBranch(owner, reponame, endCursor, hasNextPage, resultCallback)
{
    if(hasNextPage)
    {
        var nextcmd = "query { \
          repository(owner:\\\"" + owner + "\\\", name:\\\"" + reponame + "\\\") { \
            refs(refPrefix: \\\"refs/heads/\\\", first: 2, after: \\\"" + endCursor + "\\\") { \
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
        getJson(nextcmd, function(json) {
            var repo = json.data.repository;
            getNextBranch(owner, reponame, repo.refs.pageInfo.endCursor, repo.refs.pageInfo.hasNextPage, function(result)
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

function getCommit(owner, reponame, branch, resultCallback)
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

    getJson(cmd, function(json)
    {
        console.log(json);
        var commit = json.data.repository.ref.target;
        resultCallback(commit.oid, commit.message, commit.zipballUrl);
    });
}
