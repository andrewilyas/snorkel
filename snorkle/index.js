var nodes = {};
var edges = new Set();
var mode = 0; // 0 for neutral mode, 1 for adding connection, 2 for deleting layer, 3 for deleting connection
var plumber = jsPlumb.getInstance();
plumber.importDefaults({
  Connector : [ "Bezier", { curviness: 10 } ],
  Anchors : [ "Right", "Left", "TopCenter", "BottomCenter"]
});

var allString = "function createNet()\n";

function addLayer() {
    var layerDiv = document.createElement("div")
    layerDiv.className = "layer";
    layerDiv.innerText = "New Layer (Select Type)\n";
    layerDiv.id = guidGenerator();
    layerDiv.onclick = layerClicked;

    var layerTypeDropdown = document.createElement("select");
    addClass(layerTypeDropdown, "ui");
    addClass(layerTypeDropdown, "selection");
    addClass(layerTypeDropdown, "dropdown");

    layerTypeDropdown.id = layerDiv.id + "-dropdown";
    var options = ["Pick a type", "Convolution", "Simple Linear", "Max Pooling"];
    var option_values = ["none", "conv", "lin", "pool"];
    for(var i = 0; i < options.length; i++) {
        var thisOption = document.createElement("option");
        thisOption.value = option_values[i];
        thisOption.innerText = options[i];
        layerTypeDropdown.appendChild(thisOption);
    }
    layerTypeDropdown.onchange = layerTypeChanged;
    layerDiv.appendChild(layerTypeDropdown);
    document.body.appendChild(layerDiv);
    nodes[layerDiv.id] = {
        'name': null,
        'linksTo': new Set(),
        'linkedFrom': new Set()
    }
}

function layerTypeChanged(e) {
    $(e.target.parentElement).find("form").remove();
    if(e.target.value === 'conv') {
        e.target.parentElement.appendChild(makeConvForm());
    } else if (e.target.value === 'pool') {
        e.target.parentElement.appendChild(makePoolForm());
    } else if (e.target.value === 'lin') {
        e.target.parentElement.appendChild(makeLinearForm());
    }
    nodes[e.target.parentElement.id]['name'] = e.target.value;
}

function startAddingConnection() {
    mode = 1;
    addClass(document.body, "adding_connection");
}

function doneAdding() {
    mode = 0;
    removeClass(document.body, "adding_connection");
}

var currentConn = [];
function layerClicked(e) {
    if (mode == 1) {
        if (currentConn.length == 1 && currentConn[0] != e.target.id) {
            var connection = plumber.connect({
                source: currentConn[0],
                target: e.target.id,
                scope: "global",
                overlays:[
                    "Arrow"
                ]
            });
            connection.bind("click", function(conn) {
                nodes[conn.sourceId]['linksTo'].delete(conn.targetId);
                nodes[conn.targetId]['linkedFrom'].delete(conn.sourceId);
                deleteEdge(edges, [conn.sourceId, conn.targetId]);
                plumber.detach(conn);
            });

            edges.add([currentConn[0], e.target.id]);
            nodes[currentConn[0]]['linksTo'].add(e.target.id);
            nodes[e.target.id]['linkedFrom'].add(currentConn[0]);
            currentConn = [];
            doneAdding();
        } else if (currentConn.length == 1) {
            currentConn = [];
        } else if (currentConn.length == 0) {
            currentConn.push(e.target.id);
            addClass(e.target, "selected");
        }
    }
}

function assertDAG() {
    try {
        return checkIfDAG(Array.from(edges));
    } catch(err) {
        alert("NOT A DAG!")
    }
}

function assertAllLayerRequirements() {
    
}

function parseIntoGraph() {
    var luaConversions = {
        'conv': 'nn.SpatialConvolution',
        'lin': 'nn.Linear',
        'pool': 'nn.SpatialMaxPooling'
    }

    var topSort = assertDAG();
    $('form').submit();
    assertAllLayerRequirements();
    allString = "function createNet()\n";
    for (var i = 0; i < topSort.length; i++) {
        var labelId = topSort[i];
        var node = nodes[labelId];
        var paramArgs = "(" + parseForm(labelId) + ")";
        var inputArgs = "(" + Array.from(node['linkedFrom']).join(",") + ")";
        var varString;
        if(nodes[labelId]['name'] == 'lin') {
            allString += ('\t' + 'r_view_' + inputArgs.slice(1, -1) + " = nn.View" + paramArgs.split(",")[0] + ")" + inputArgs + "\n");
            varString = labelId + " = " + luaConversions[node['name']] + paramArgs + "(r_view_" + inputArgs.slice(1,-1) + ")";
        } else {
            varString = labelId + " = " + luaConversions[node['name']] + paramArgs + inputArgs;
        }
        allString += ("\t" + varString + "\n");
    }
    allString += "\n \
\tsoft_max = nn.LogSoftMax()(" + topSort[topSort.length-1] + ")\n \
\tlocal net = nn.gModule({" + topSort[0] + "}, {soft_max})\n \
\tlocal function weights_init(m)\n \
\t\tlocal name = torch.type(m)\n \
\t\tif name:find('Convolution') then\n \
\t\t\tm.weight:normal(0.0, 0.01)\n \
\t\t\tm.bias:fill(0)\n \
\t\telseif name:find('BatchNormalization') then\n \
\t\t\tif m.weight then m.weight:normal(1.0, 0.02) end\n \
\t\t\tif m.bias then m.bias:fill(0) end\n \
\t\tend\n \
\tend\n \
\tnet:apply(weights_init)\n \
\treturn net\n\
end \
"
    askForInputs();
    console.log(allString);
}


