import QtQuick 2.0
import util 1.0
import "../request.js" as Request

HomeForm {
    anchors.fill: parent

    property int selectedProjectIndex: 0;

    ListModel {
        id: projectsModel
    }

    ListModel {
        id: projectsInfosList
    }

    ListModel {
        id: branchesModel
    }

    Sha1Sum {
        id: sha1sumObject

        onStarted: {
            progressBar.opacity = 1.0;
        }

        onProgress: {
            progressBar.to = bytesTotal;
            progressBar.value = bytesReceived;
        }

        onFinished: {
            progressBar.opacity = 0.0;
            sha1sumOutput.clear();
            sha1sumOutput.text = result;
        }
    }

    projectComboBox.model: projectsModel
    branchComboBox.model: branchesModel

    clearButton.onClicked: {
        projectComboBox.displayText = "Project";
        branchComboBox.displayText = "Branches";

        branchesModel.clear();
        commitIdOutput.clear();
        commitMessageOutput.clear();
        urlOutput.clear();
        sha1sumOutput.clear();
        getProjects();
    }

    function getProjects()
    {
        projectsModel.clear();
        projectsInfosList.clear();

        projectsModel.append({text: "macchina.io"});
        projectsInfosList.append({reponame: "macchina.io", owner: "Bjoe" });
    }

    projectComboBox.onActivated: {
        selectedProjectIndex = index;
        var project = projectsModel.get(selectedProjectIndex);
        projectComboBox.displayText = project.name;

        var projectInfo = projectsInfosList.get(selectedProjectIndex);

        Request.getBranches(projectInfo.owner, projectInfo.reponame, function(result)
        {
            branchesModel.clear();
            for(var i = 0; i < result.length; i++) {
                branchesModel.append({text: result[i].node.name});
            }
        });
      }

    branchComboBox.onActivated: {
        var branch = branchesModel.get(index);
        branchComboBox.displayText = branch.text;

        getCommits(branch.text);
    }

    function getCommits(branch)
    {
        var projectInfo = projectsInfosList.get(selectedProjectIndex);

       Request.getCommit(projectInfo.owner, projectInfo.reponame, branch,
                        function(oid, message, zipballUrl)
                        {
                            commitIdOutput.text = oid;
                            commitMessageOutput.text = message;
                            urlOutput.text = zipballUrl;
                            sha1sumObject.start(urlOutput.text);
                        });
    }

    copyIdbutton.onClicked: {
        commitIdOutput.selectAll();
        commitIdOutput.copy();
        commitIdOutput.deselect();
    }

    copyUrlbutton.onClicked: {
        urlOutput.selectAll();
        urlOutput.copy();
        urlOutput.deselect();
    }

    copyShabutton.onClicked: {
        sha1sumOutput.selectAll();
        sha1sumOutput.copy();
        sha1sumOutput.deselect();
    }

    Component.onCompleted: {
        getProjects();
    }
}
