class Curve
{
   ArrayList<Node> m_Nodes;
   
   Curve(ArrayList<Node> initialConfig)
   {
      m_Nodes = initialConfig; 
   }
   
   Curve()
   {
      m_Nodes = new ArrayList<Node>();
   }
   
   void SetNodes(ArrayList<Node> newNodes)
   {
      m_Nodes = newNodes; 
   }
   
   void Update()
   {
      for (Node node : m_Nodes)
      {
         PVector nodeVelocity = PVector.sub(node.m_Pos, node.m_PrevPos);
         node.m_PrevPos = node.m_Pos.copy();
         node.m_Pos.add(PVector.mult(nodeVelocity, g_NodeVelocityDragFactor));
      }  
      
      for (int nodeIter = 0; nodeIter < m_Nodes.size(); ++nodeIter)
       {
          Node node = m_Nodes.get(nodeIter);
          Node nodeLeft = m_Nodes.get((nodeIter == 0) ? m_Nodes.size()-1 : nodeIter-1);
          Node nodeRight = m_Nodes.get((nodeIter+1)%m_Nodes.size());
          for (Node otherNode : m_Nodes)
          {
             if (otherNode != node && otherNode != nodeLeft && otherNode != nodeRight)
             {
               float nodeDist = otherNode.m_Pos.dist(node.m_Pos);
               if (IsLesserOrEqualWithEpsilon(nodeDist, g_RepulsionRange))
               {
                   PVector nodeDir = PVector.sub(otherNode.m_Pos, node.m_Pos);
                   nodeDir.normalize();
                   
                   PVector repulsionForceForNode = PVector.mult(nodeDir, -(g_RepulsionRange - nodeDist)*g_RepulsionSpringConstant);
                   otherNode.m_Pos.sub(repulsionForceForNode);
                   node.m_Pos.add(repulsionForceForNode);
               }
             }
          }
       }
     
      for (int nodeIter = 0; nodeIter < m_Nodes.size(); ++nodeIter)
      {
        Node nodeA = m_Nodes.get(nodeIter);
        Node nodeB = m_Nodes.get((nodeIter+1)%m_Nodes.size());
        
        ConstrainNodes(nodeA, nodeB, g_NeighbourIdealProximity);
      } //<>// //<>// //<>//
      
      if (IsLesserWithEpsilon(random(1.0), g_ChanceToAddNewNode))
      {
        int recordNodeIter = -1;
        float recordAngle = 0.0f;
        
        for (int nodeIter = 0; nodeIter < m_Nodes.size(); ++nodeIter)
        {
           Node nodeA = m_Nodes.get((nodeIter == 0 ? m_Nodes.size() -1 : nodeIter - 1));
           Node node = m_Nodes.get(nodeIter);
           Node nodeB = m_Nodes.get((nodeIter+1)%m_Nodes.size());
           
           PVector leftEdgeDir = PVector.sub(nodeA.m_Pos, node.m_Pos);
           leftEdgeDir.normalize();
           
           PVector rightEdgeDir = PVector.sub(nodeB.m_Pos, node.m_Pos);
           rightEdgeDir.normalize();
           
           float angleBetweenEdges = PVector.angleBetween(leftEdgeDir, rightEdgeDir);
           if (IsGreaterWithEpsilon(abs(angleBetweenEdges), abs(recordAngle)))
           {
              recordAngle = angleBetweenEdges;
              recordNodeIter = nodeIter;
           }
        }

        if (recordNodeIter != -1)
        {
          boolean bAddLeftNode = IsLesserWithEpsilon(random(1.0), 0.5f);
          Node recordNode = m_Nodes.get(recordNodeIter);
          Node edgeNode;
          int newNodeIter;
          if (bAddLeftNode)
          {
           newNodeIter = (recordNodeIter == 0 ? m_Nodes.size()-1 : recordNodeIter - 1);
           edgeNode = m_Nodes.get(newNodeIter); 
          }
          else
          {
            newNodeIter = (recordNodeIter+1)%(m_Nodes.size());
            edgeNode = m_Nodes.get(newNodeIter); 
          }
          
          PVector edgeDir = PVector.sub(edgeNode.m_Pos, recordNode.m_Pos);
          float edgeDist = edgeDir.mag();
          edgeDir.normalize();
          
          Node newNode = new Node(PVector.add(recordNode.m_Pos, PVector.mult(edgeDir, edgeDist/2)), g_NodeDiameter);
          
          m_Nodes.add(newNodeIter, newNode);
        }
      }
   }
   
   void ConstrainNodes(Node nodeA, Node nodeB, float idealDist)
   {
     PVector dispNodes = PVector.sub(nodeB.m_Pos, nodeA.m_Pos);
     float nodeDist = dispNodes.mag();
     
     float fractionalRatio = (idealDist - nodeDist)/(2*nodeDist);
     PVector distConstraintForce = PVector.mult(dispNodes, fractionalRatio);
     
     nodeB.m_Pos.add(distConstraintForce);
     nodeA.m_Pos.sub(distConstraintForce);
   }
   
   void Display()
   {
      strokeWeight(3);
       
      for (int nodeIter = 0; nodeIter < m_Nodes.size(); ++nodeIter)
      {
        Node nodeA = m_Nodes.get(nodeIter);
        Node nodeB = m_Nodes.get((nodeIter+1)%m_Nodes.size());
        
        line(nodeA.m_Pos.x, nodeA.m_Pos.y, nodeB.m_Pos.x, nodeB.m_Pos.y);
      }
   }
}
