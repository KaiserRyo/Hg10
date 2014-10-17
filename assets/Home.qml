import bb.cascades 1.2
import Network.ListContactsController 1.0
import com.netimage 1.0

NavigationPane {
    id: nav
    property variant tpage
    property int depth


    Page {
        titleBar: TitleBar {
            kind: TitleBarKind.FreeForm
            kindProperties: FreeFormTitleBarKindProperties {
                Container {
                    layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                    leftPadding: 10
                    rightPadding: 10
                    
                    ImageView {
                        verticalAlignment: VerticalAlignment.Center
                        //horizontalAlignment: HorizontalAlignment.Left
                        id: avatarOwnImg
                        scalingMethod: ScalingMethod.AspectFit
                        minHeight: 90
                        maxHeight: 90
                        minWidth: 90
                        maxWidth: 90
                        image: trackerOwn.image
                        
                        attachedObjects: [
                            NetImageTracker {
                                id: trackerOwn
                                
                                source: listContactsController.avatar                                    
                            } 
                        ]
                    }
                    
                    Label {
                        text: listContactsController.userName
                        textStyle {
                            color: Color.Black
                        }
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties { spaceQuota: 1 }
                    }
                }
            }
        }
        
        Container {
            ListView {
                id: listContactView
                dataModel: GroupDataModel {
                    id: theModel
                    sortingKeys: ["category"]
                    
                    property bool empty: true
                    
                    
                    onItemAdded: empty = isEmpty()  
                    onItemRemoved: empty = isEmpty()  
                    onItemUpdated: empty = isEmpty()  
                    
                    // You might see an 'unknown signal' error  
                    // in the QML-editor, guess it's a SDK bug.  
                    onItemsChanged: empty = isEmpty()
                
                }
                
                listItemComponents: [
                    ListItemComponent {
                        type: "header"
                        Header {
                            title: ListItemData
                        }
                    },
                    ListItemComponent {
                        type: "item"
                        
                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.TopToBottom
                            }
                            horizontalAlignment: HorizontalAlignment.Fill
                            verticalAlignment: VerticalAlignment.Fill
                            
                            Container {
                                minHeight: 5
                                maxHeight: 5
                            }
                            
                            Container {
                                preferredHeight: 100
                                
                                id: titleContainer
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                                
                                Container {
                                    minWidth: 5
                                    maxWidth: 5
                                }
                                
                                Container {
                                    layout: AbsoluteLayout { }
                                    minHeight: 90
                                    maxHeight: 90
                                    minWidth: 90
                                    maxWidth: 90

                                    //  Avatar
                                    ImageView {
                                        verticalAlignment: VerticalAlignment.Center
                                        //horizontalAlignment: HorizontalAlignment.Left
                                        id: avatarImg
                                        scalingMethod: ScalingMethod.AspectFit
                                        minHeight: 90
                                        maxHeight: 90
                                        minWidth: 90
                                        maxWidth: 90
                                        image: tracker.image
                                        
                                        attachedObjects: [
                                            NetImageTracker {
                                                id: tracker
                                                
                                                source: ListItemData.avatar                                    
                                            } 
                                        ]
                                    
                                    }
                                    
                                    ImageView {
                                        imageSource: "asset:///images/available.png"
                                        minHeight: 20
                                        maxHeight: 20
                                        minWidth: 20
                                        maxWidth: 20
                                        layoutProperties: AbsoluteLayoutProperties {
                                            positionX: 70
                                            positionY: 70
                                        }
                                        // 0 => online, 1 => away, 2 => away (long time), 3 => do not disturb, 4 => actively interested into chatting, 
                                        visible: ListItemData.presence == 0
                                    }
                                    
                                }
                                
                                Container {
                                    minWidth: 30
                                    maxWidth: 30
                                    //horizontalAlignment: HorizontalAlignment.Left
                                    
                                }
                                
                                Container {
                                    id: contactContainer
                                    preferredWidth: 2000
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.TopToBottom
                                    }
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    verticalAlignment: VerticalAlignment.Center
                                    
                                    Container {
                                        layout: DockLayout {
                                        }
                                        horizontalAlignment: HorizontalAlignment.Fill
                                        verticalAlignment: VerticalAlignment.Center
                                        
                                        Label {
                                            text: ListItemData.name
                                        }
                                        
                                        Label {
                                            text: ListItemData.timestamp
                                            horizontalAlignment: HorizontalAlignment.Right
                                            verticalAlignment: VerticalAlignment.Center
                                            textStyle {
                                                base: SystemDefaults.TextStyles.SmallText
                                                color: (ListItemData.read == 1) ? Color.Gray : (Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.create("#00a8df") : Color.Blue);
                                            }
                                        }
                                    }
                                    
                                    
                                    Container {
                                        layout: DockLayout {
                                        }
                                        horizontalAlignment: HorizontalAlignment.Fill
                                        verticalAlignment: VerticalAlignment.Bottom
                                        
                                        
                                        Label {
                                            text: ListItemData.preview
                                            horizontalAlignment: HorizontalAlignment.Left
                                            textStyle {
                                                base: SystemDefaults.TextStyles.SmallText
                                                color: (ListItemData.read == 1) ? Color.Gray : (Application.themeSupport.theme.colorTheme.style == VisualStyle.Dark ? Color.create("#00a8df") : Color.Blue);
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            Divider {
                                
                            }
                            
                        }
                    }
                ]
                
                onTriggered: {
                    var chosenItem = dataModel.data(indexPath);
                    
                    // Create the content page and push it on top to drill down to it.
                    if(!tpage) {
                        tpage = conversation.createObject();
                    }
                    
                    // Set the url of the page to load and thread caption. 
                    tpage.name     = chosenItem.name;
                    tpage.avatar   = chosenItem.avatar;
                    tpage.id       = chosenItem.id;
                    
                    nav.push(tpage);
                }
                
            }
        }
        
        onCreationCompleted: {
            listContactsController.setListView(listContactView);
            listContactsController.updateView();
            depth = 0;
        }
        
        attachedObjects: [
            ListContactsController {
                id: listContactsController
            },
            ComponentDefinition {
                id: conversation
                source: "Conversation.qml"
            }
        ]
    
    }
    
    onPushTransitionEnded: {
        ++depth;
        console.log(depth)
    }
    
    onPopTransitionEnded: {
        --depth;
        if(depth == 1) {
            listContactsController.markRead();
            if(tpage) 
                tpage.id = "";
        }
        console.log(depth)
    }
}