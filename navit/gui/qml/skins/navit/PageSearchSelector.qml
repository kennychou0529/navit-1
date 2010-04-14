
import Qt 4.6

Rectangle {
      id: page

      width: gui.width; height: gui.height
      color: "Black"
      opacity: 0

      function setSearchResult(listValue) {
          if (search.searchContext=="country") {
	      search.countryName=listValue;
	      gui.backToPrevPage();
	  }
          if (search.searchContext=="town") {
	      search.townName=listValue;
	      gui.backToPrevPage();
	  }
          if (search.searchContext=="street") {
	      search.streetName=listValue;
	      search.setPointToResult();
	      gui.setPage("PageNavigate.qml");
	  }
      }

      function pageOpen() {
          if (search.searchContext=="country") {
	      searchTxt.text=search.countryName;
	      countryBinding.when=true;
	  }
          if (search.searchContext=="town") {
	      searchTxt.text=search.townName;
	      townBinding.when=true;
	  }
          if (search.searchContext=="street") {
	      searchTxt.text=search.streetName;
	      streetBinding.when=true;
	  }
          page.opacity = 1;
      }
    
      Component.onCompleted: pageOpen();    
    
      opacity: Behavior {
          NumberAnimation { id: opacityAnimation; duration: 300; alwaysRunToEnd: true }
      }

     TextInput{
     	  id: searchTxt; 
	  anchors.top: parent.top; anchors.left: parent.left; anchors.topMargin: gui.height/16; anchors.leftMargin: gui.width/32
	  width: page.width; font.pointSize: 14; color: "White";focus: true; readOnly: false; cursorVisible: true;
     }
    Binding {id: countryBinding; target: search; property: "countryName"; value: searchTxt.text; when: false}
    Binding {id: townBinding; target: search; property: "townName"; value: searchTxt.text; when: false}
    Binding {id: streetBinding; target: search; property: "streetName"; value: searchTxt.text; when: false}

    XmlListModel {
	id: listModel
	xml: search.searchXml;
	query: "/search/item"
	XmlRole { name: "itemId"; query: "id/string()" }
	XmlRole { name: "itemName"; query: "name/string()" }
	XmlRole { name: "itemIcon"; query: "icon/string()" }
    }

   Component {
         id: listDelegate
         Item {
             id: wrapper
             width: list.width; height: 20
		 Image {
			id: imgIcon; source: gui.iconPath+itemIcon
			width: 20; height: 20;
		}
                Text { 
		    id: txtItemName; text: itemName; color: "White"; 
		    anchors.left: imgIcon.right;anchors.leftMargin: 5
		    width: list.width-imgIcon.width
		}
	        MouseRegion {
	   	    id:delegateMouse
		    anchors.fill: parent
		    onClicked: { setSearchResult(itemName); }
	     }
         }
     }

    Component {
        id: listHighlight
        Rectangle {
	    opacity: 0
        }
    }

    ListSelector { 
	id:layoutList; text: search.searchContext; onChanged: setSearchResult()
	anchors.top: searchTxt.bottom; anchors.left: parent.left; anchors.topMargin: gui.height/16; anchors.leftMargin: gui.width/32
	width: page.width; height: page.height/2-cellar.height
    }

    Cellar {id: cellar; anchors.bottom: page.bottom; anchors.horizontalCenter: page.horizontalCenter; width: page.width }
}
