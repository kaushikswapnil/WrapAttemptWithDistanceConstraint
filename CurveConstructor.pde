class CurveConstructor
{
   ArrayList<Node> m_Nodes;
   
   Node m_CurrentLinkNodeA;
   Node m_CurrentLinkNodeB;
   
   int m_DragOperationMode;
   
   CurveConstructor()
   {
      m_Nodes = new ArrayList<Node>();
      
      m_DragOperationMode = 0;
      
      m_CurrentLinkNodeA = null;
      m_CurrentLinkNodeB = null;
   }
   
   void TransferNodesToCurve()
   {
     if (m_DragOperationMode != 0)
     {
       ReleaseLink();
       m_DragOperationMode = 0;
     }
     
     g_Curve.SetNodes(m_Nodes);
     m_Nodes = new ArrayList<Node>();
   }
  
   void Display()
   {
     for (Node node : m_Nodes)
     {
       node.Display();
       
       stroke(0, 255, 0);
     }
   }
   
   boolean IsFreePosition(float posX, float posY)
   {
     boolean isFreePosition = true;
     for (Node node : m_Nodes)
     {
       if (IsLesserWithEpsilon(node.GetClosestDistanceToNodeSurface(new PVector(posX, posY)), 0.0f))
       {
         isFreePosition = false;
         break;
       }
     }
     
     return isFreePosition;
   }
   
   void AddNode(float posX, float posY)
   {
     m_Nodes.add(new Node(new PVector(posX, posY), 8));    
   }
   
   void OnMouseDragged(float posX, float posY)
   {
       PVector mousePos = new PVector(posX, posY);
       switch(m_DragOperationMode)
       {
          case 0://Idle
          m_DragOperationMode = 1;
          for (Node node : m_Nodes)
          {
            if (IsLesserOrEqualWithEpsilon(node.GetClosestDistanceToNodeSurface(mousePos), 0.0f))
            {
              m_CurrentLinkNodeA = node;
              m_DragOperationMode = 2;
              break;
            }
          }
          break;
          
          case 1://Drag with no selection
          //do nothing
          break;
          
          case 2://Drag with wait for node B
          //do nothing
          break;
       }
   }
   
   void OnMouseReleased(float posX, float posY)
   {
       switch(m_DragOperationMode)
       {
          case 0://Idle
          //do nothing
          break;
          
          case 1://Drag with no selection
          m_DragOperationMode = 0; //Release drag
          break;
          
          case 2://Drag with wait for node B
          {
              PVector mousePos = new PVector(posX, posY); 
              for (Node node : m_Nodes)
              {
                if (IsLesserOrEqualWithEpsilon(node.GetClosestDistanceToNodeSurface(mousePos), 0.0f))
                {
                  m_CurrentLinkNodeB = node;
                  CreateLink();
                  m_DragOperationMode = 0;
                  break;
                }
              }
              
              if (m_DragOperationMode != 0)
              {
                 ReleaseLink(); 
                 m_DragOperationMode = 0;
              }
          }
          break;
       }
   }
   
   void CreateLink()
   {
     
     ReleaseLink();
   }
   
   void ReleaseLink()
   {

   }
}
