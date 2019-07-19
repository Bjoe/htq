import QtQuick 2.0
import util 1.0
import QtQuick.Dialogs 1.3 as QtQuick
import QtQuick.Controls 2.4 as Controls
import Qt.labs.settings 1.0
import "../githubRequest.js" as GithubRequest
import "../gitlabRequest.js" as GitlabRequest

HomeForm {
    id: home
    anchors.fill: parent

    property int currentGitTypeIndex: 0;

    property string gitlabUrlData: ""
    property string githubUrlData: ""
    property string ownerData: ""
    property string gitlabProjectsData: ""
    property string githubProjectsData: ""

    Settings {
        id: mainSettings
        category: "MainSettings"

        property alias gitlabUrlData: home.gitlabUrlData
        property alias githubUrlData: home.githubUrlData
        property alias ownerData: home.ownerData
        property alias gitlabProjectsData: home.gitlabProjectsData
        property alias githubProjectsData: home.githubProjectsData
    }

    ListModel {
        id: typeModel

        ListElement {
            text: "GitHub"
        }

        ListElement {
            text: "GitLab"
        }
    }

    ListModel {
        id: gitlabUrlModel
    }

    ListModel {
        id: githubUrlModel
    }

    ListModel {
        id: ownerModel
    }

    ListModel {
        id: gitlabProjectsModel
    }

    ListModel {
        id: githubProjectsModel
    }

    ListModel {
        id: branchesModel
    }

    typeComboBox.model: typeModel
    branchComboBox.model: branchesModel

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

    function clear()
    {
        branchesModel.clear();
        commitIdOutput.clear();
        commitMessageOutput.clear();
        urlOutput.clear();
        sha1sumOutput.clear();

        branchComboBox.displayText = "Branch";
    }

    clearButton.onClicked: {
        clear();
    }

    typeComboBox.onActivated: {
        currentGitTypeIndex = index;
        typeComboBox.displayText = typeModel.get(index).name

        urlComboBox.enabled = true;
        urlComboBox.displayText = "Git url";
        ownerComboBox.enabled = false;
        ownerComboBox.displayText = "Owner";
        projectComboBox.enabled = false;
        projectComboBox.displayText = "Project";
        branchComboBox.enabled = false;
        branchComboBox.displayText = "Branch";

        clear();

        if(currentGitTypeIndex === typeComboBox.find("GitLab"))
        {
            urlComboBox.model = gitlabUrlModel;
            projectComboBox.model = gitlabProjectsModel;
        }
        else
        {
            urlComboBox.model = githubUrlModel;
            ownerComboBox.model = ownerModel;
            projectComboBox.model = githubProjectsModel;
        }
    }

    urlMouseArea.acceptedButtons: Qt.RightButton
    urlMouseArea.onClicked: {
            if (mouse.button === Qt.RightButton)
                urlContextMenu.popup()
        }

    urlMouseArea.data: [
        Controls.Menu {
            id: urlContextMenu
            Controls.MenuItem {
                text: "Edit"
                onTriggered: {
                    if(urlComboBox.currentIndex === -1 ||
                       urlComboBox.currentIndex === urlComboBox.find("Add URL"))
                    {
                        return;
                    }
                    if(currentGitTypeIndex === typeComboBox.find("GitLab"))
                    {
                        var gitlabUrlObject = gitlabUrlModel.get(urlComboBox.currentIndex);
                        urlDialog.gitlabUrlDialog.urlEdit.text = gitlabUrlObject.text;
                        urlDialog.gitlabUrlDialog.passwordEdit.text = gitlabUrlObject.privtoken;
                        gitlabUrlModel.remove(urlComboBox.currentIndex);
                    }
                    else
                    {
                        var githubUrlObject = githubUrlModel.get(urlComboBox.currentIndex);
                        urlDialog.githubUrlDialog.urlEdit.text = githubUrlObject.text;
                        urlDialog.githubUrlDialog.usernameEdit.text = githubUrlObject.username;
                        urlDialog.githubUrlDialog.passwordEdit.text = githubUrlObject.passwd;
                        githubUrlModel.remove(urlComboBox.currentIndex);
                    }
                    urlDialog.open()
                }
            }
            Controls.MenuItem {
                text: "Delete"
                onTriggered: {
                    if(urlComboBox.currentIndex === -1 ||
                       urlComboBox.currentIndex === urlComboBox.find("Add URL"))
                    {
                        return;
                    }
                    if(currentGitTypeIndex === typeComboBox.find("GitLab"))
                    {
                        gitlabUrlModel.remove(urlComboBox.currentIndex);
                    }
                    else
                    {
                        githubUrlModel.remove(urlComboBox.currentIndex);
                    }
                }
            }
        }
    ]

    urlComboBox.onActivated: {
        if(currentGitTypeIndex === typeComboBox.find("GitLab"))
        {
            gitlabUrlDialog.enabled = true;
            gitlabUrlDialog.visible = true;
            githubUrlDialog.enabled = false;
            githubUrlDialog.visible = false;
            ownerComboBox.enabled = false;
            ownerComboBox.displayText = "Owner";
            projectComboBox.enabled = true;
            projectComboBox.displayText = "Project";
        }
        else
        {
            githubUrlDialog.enabled = true;
            githubUrlDialog.visible = true;
            gitlabUrlDialog.enabled = false;
            gitlabUrlDialog.visible = false;
            ownerComboBox.enabled = true;
            ownerComboBox.displayText = "Owner";
            projectComboBox.enabled = false;
            projectComboBox.displayText = "Project";
        }

        if(index === urlComboBox.find("Add URL"))
        {
            urlDialog.open();
        }
        else
        {
            if(currentGitTypeIndex === typeComboBox.find("GitLab"))
            {
                var gitlabUrlObject = gitlabUrlModel.get(index);
                GitlabRequest.giturl = gitlabUrlObject.text;
                GitlabRequest.privtoken = gitlabUrlObject.privtoken;
                urlComboBox.displayText = gitlabUrlObject.text;
            }
            else
            {
                var githubUrlObject = githubUrlModel.get(index);
                GithubRequest.giturl = githubUrlObject.text;
                var data = "" + githubUrlObject.username + ":" + githubUrlObject.passwd + "";
                var urlPassword = Qt.btoa(data);
                GithubRequest.passwd = urlPassword;
                urlComboBox.displayText = githubUrlObject.text;
            }
        }

        branchComboBox.enabled = false;
        branchComboBox.displayText = "Branch";
    }

    QtQuick.Dialog {
        id: urlDialog
        title: "URL"
        width: 500
        height: 200

        property alias githubUrlDialog: githubUrlDialog
        property alias gitlabUrlDialog: gitlabUrlDialog

        GitHubUrl {
            id: githubUrlDialog
            enabled: false
            visible: false

            function set(index) {
                githubUrlModel.insert(index, {text: urlEdit.text, username: usernameEdit.text, passwd: passwordEdit.text});

                GithubRequest.giturl = urlEdit.text;
                var data = "" + usernameEdit.text + ":" + passwordEdit.text + "";
                var urlPassword = Qt.btoa(data);
                GithubRequest.passwd = urlPassword;
                urlComboBox.displayText = urlEdit.text;

                urlEdit.clear();
                usernameEdit.clear();
                passwordEdit.clear();
            }

            Component.onCompleted: {
                if(urlEdit.text === "")
                {
                    urlEdit.text = "https://api.github.com/graphql";
                }
            }
        }

        GitLabUrl {
            id: gitlabUrlDialog
            enabled: false
            visible: false

            function set(index) {
                gitlabUrlModel.insert(index, {text: urlEdit.text, privtoken: passwordEdit.text});

                GitlabRequest.giturl = urlEdit.text;
                GitlabRequest.privtoken = passwordEdit.text;
                urlComboBox.displayText = urlEdit.text;

                urlEdit.clear();
                passwordEdit.clear();
            }
        }

        onAccepted: {
            var index = urlComboBox.find("Add URL")
            if(currentGitTypeIndex === typeComboBox.find("GitLab"))
            {
                gitlabUrlDialog.set(index);
            }
            else
            {
                githubUrlDialog.set(index);
            }
        }
    }

    ownerMouseArea.acceptedButtons: Qt.RightButton
    ownerMouseArea.onClicked: {
            if (mouse.button === Qt.RightButton)
                ownerContextMenu.popup()
        }

    ownerMouseArea.data: [
        Controls.Menu {
            id: ownerContextMenu
            Controls.MenuItem {
                text: "Edit"
                onTriggered: {
                    if(ownerComboBox.currentIndex === -1 ||
                       ownerComboBox.currentIndex === ownerComboBox.find("Add owner"))
                    {
                        return;
                    }
                    var githubOwnerObject = ownerModel.get(ownerComboBox.currentIndex);
                    ownerDialog.githubOwnerDialog.ownerEdit.text = githubOwnerObject.text;
                    ownerModel.remove(ownerComboBox.currentIndex);
                    ownerDialog.open();
                }
            }
            Controls.MenuItem {
                text: "Delete"
                onTriggered: {
                    if(ownerComboBox.currentIndex === -1 ||
                       owenrComboBox.currentIndex === ownerComboBox.find("Add owner"))
                    {
                        return;
                    }
                    ownerModel.remove(ownerComboBox.currentIndex);
                }
            }
        }
    ]

    ownerComboBox.onActivated: {
        if(index === ownerComboBox.find("Add owner"))
        {
            ownerDialog.open();
        }
        else
        {
            var ownerObject = ownerModel.get(index);
            ownerComboBox.displayText = ownerObject.text;
        }

        projectComboBox.enabled = true;
        projectComboBox.displayText = "Project";
    }

    QtQuick.Dialog {
        id: ownerDialog
        title: "Owner"
        width: 500
        height: 200

        property alias githubOwnerDialog: githubOwnerDialog
        GitHubOwner {
            id: githubOwnerDialog
        }

        onAccepted: {
            var index = ownerComboBox.find("Add owner");
            ownerModel.insert(index, {text: githubOwnerDialog.ownerEdit.text});
            ownerComboBox.displayText = githubOwnerDialog.ownerEdit.text;
            githubOwnerDialog.ownerEdit.clear();
        }
    }

    projectMouseArea.acceptedButtons: Qt.RightButton
    projectMouseArea.onClicked: {
            if (mouse.button === Qt.RightButton)
                projectContextMenu.popup()
        }

    projectMouseArea.data: [
        Controls.Menu {
            id: projectContextMenu
            Controls.MenuItem {
                text: "Edit"
                onTriggered: {
                    if(projectComboBox.currentIndex === -1 ||
                       projectComboBox.currentIndex === projectComboBox.find("Add project"))
                    {
                        return;
                    }
                    if(currentGitTypeIndex === typeComboBox.find("GitLab"))
                    {
                        var gitlabProjectObject = gitlabProjectsModel.get(projectComboBox.currentIndex);
                        projectDialog.gitlabProjectDialog.projectEdit.text = gitlabProjectObject.id;
                        gitlabProjectsModel.remove(projectComboBox.currentIndex);
                    }
                    else
                    {
                        var githubProjectObject = githubProjectsModel.get(projectComboBox.currentIndex);
                        projectDialog.githubProjectDialog.projectEdit.text = githubProjectObject.text;
                        githubProjectsModel.remove(projectComboBox.currentIndex);
                    }
                    projectDialog.open()
                }
            }
            Controls.MenuItem {
                text: "Delete"
                onTriggered: {
                    if(projectComboBox.currentIndex === -1 ||
                       projectComboBox.currentIndex === projectComboBox.find("Add project"))
                    {
                        return;
                    }
                    if(currentGitTypeIndex === typeComboBox.find("GitLab"))
                    {
                        gitlabProjectsModel.remove(projectComboBox.currentIndex);
                    }
                    else
                    {
                        githubProjectsModel.remove(projectComboBox.currentIndex);
                    }
                }
            }
        }
    ]

    projectComboBox.onActivated: {
        if(currentGitTypeIndex === typeComboBox.find("GitLab"))
        {
            gitlabProjectDialog.enabled = true;
            gitlabProjectDialog.visible = true;
            githubProjectDialog.enabled = false;
            githubProjectDialog.visible = false;
        }
        else
        {
            githubProjectDialog.enabled = true;
            githubProjectDialog.visible = true;
            gitlabProjectDialog.enabled = false;
            gitlabProjectDialog.visible = false;
        }

        if(index === projectComboBox.find("Add project"))
        {
            projectDialog.open();
        }
        else
        {
            if(currentGitTypeIndex === typeComboBox.find("GitLab"))
            {
                var gitlabProjectObject = gitlabProjectsModel.get(index);
                projectComboBox.displayText = gitlabProjectObject.text;
                getGitlabBranches(gitlabProjectObject.id);
            }
            else
            {
                var githubProjectObject = githubProjectsModel.get(index);
                projectComboBox.displayText = githubProjectObject.text;
                getGithubBranches(githubProjectObject.text);
            }

        }
        branchComboBox.enabled = true;
        branchComboBox.displayText = "Branch";
    }

    function getGitlabBranches(projectId)
    {
        GitlabRequest.getBranches(projectId, function(json)
                        {
                            branchesModel.clear();
                            for(var i = 0; i < json.length; i++) {
                                branchesModel.append({text: json[i].name});
                            }
                        });

    }

    function getGithubBranches(projectName)
    {
        GithubRequest.getGithubBranches(ownerComboBox.currentText, projectName, function(result)
        {
            branchesModel.clear();
            for(var i = 0; i < result.length; i++) {
                branchesModel.append({text: result[i].node.name});
            }
        });
    }

    QtQuick.Dialog {
        id: projectDialog
        title: "Project"
        width: 500
        height: 200

        property alias githubProjectDialog: githubProjectDialog
        property alias gitlabProjectDialog: gitlabProjectDialog

        GitHubProject {
            id: githubProjectDialog
            enabled: false
            visible: false

            function set(index) {
                githubProjectsModel.insert(index, {text: projectEdit.text});
                projectComboBox.displayText = projectEdit.text;
                getGithubBranches(projectEdit.text);

                projectEdit.clear();
            }
        }

        GitLabProject {
            id: gitlabProjectDialog
            enabled: false
            visible: false

            function set(index) {
                var projectId = projectEdit.text;
                GitlabRequest.getProjects(projectId, function(json)
                                {
                                    gitlabProjectsModel.insert(index, {text: json.name, id: json.id, web_url: json.web_url});
                                    projectComboBox.displayText = json.name;
                                });
                getGitlabBranches(projectId);

                projectEdit.clear();
            }
        }

        onAccepted: {
            var index = projectComboBox.find("Add project");
            if(currentGitTypeIndex === typeComboBox.find("GitLab"))
            {
                gitlabProjectDialog.set(index);
            }
            else
            {
                githubProjectDialog.set(index);
            }
        }
    }

    branchComboBox.onActivated: {
        var branchObject = branchesModel.get(index);
        branchComboBox.displayText = branchObject.text;

        if(currentGitTypeIndex === typeComboBox.find("GitLab"))
        {
            getGitlabCommits(branchObject.text)
        }
        else
        {
            getGithubCommits(branchObject.text)
        }
    }

    function getGitlabCommits(branch)
    {
        var projectId = gitlabProjectsModel.get(projectComboBox.currentIndex).id;
        GitlabRequest.getCommit(projectId, branch, function(json)
                        {
                            commitIdOutput.text = json.commit.id;
                            commitMessageOutput.text = json.commit.title;
                            var webUrl = gitlabProjectsModel.get(projectComboBox.currentIndex).web_url;
                            urlOutput.text = webUrl + "/repository/" + json.commit.id + "/archive.tar.gz";
                            sha1sumObject.start(urlOutput.text + "?private_token=" + GitlabRequest.privtoken);
                        });

    }

    function getGithubCommits(branch)
    {
       GithubRequest.getGithubCommit(ownerComboBox.currentText, projectComboBox.currentText, branch,
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
        clear();

        restoreData(gitlabUrlData, gitlabUrlModel, "Add URL");
        restoreData(githubUrlData, githubUrlModel, "Add URL");
        restoreData(ownerData, ownerModel, "Add owner");
        restoreData(gitlabProjectsData, gitlabProjectsModel, "Add project");
        restoreData(githubProjectsData, githubProjectsModel, "Add project");
    }

    function restoreData(data, listModel, textContent)
    {
        listModel.clear();
        if(data)
        {
            var dataModel = JSON.parse(data);
            for (var i = 0; i < dataModel.length; ++i)
            {
                listModel.append(dataModel[i]);
            }
        }
        else
        {
            listModel.append({text: textContent});
        }
    }

    function closeApplication()
    {
        gitlabUrlData = saveData(gitlabUrlModel);
        githubUrlData = saveData(githubUrlModel);
        ownerData = saveData(ownerModel);
        gitlabProjectsData = saveData(gitlabProjectsModel);
        githubProjectsData = saveData(githubProjectsModel);
    }

    function saveData(listModel)
    {
        var dataModel = []
        for (var i = 0; i < listModel.count; ++i)
        {
            dataModel.push(listModel.get(i))
        }
        return JSON.stringify(dataModel);
    }
}
