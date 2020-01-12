class Node
{
   PVector m_Pos;
   PVector m_PrevPos;
   float m_Diameter;
   
   PVector m_Acceleration;
   
   float m_Mass;
   
   Node m_Left, m_Right;
   
   Node(PVector position, float diameter)
   {
      m_Pos = position.get();
      m_PrevPos = m_Pos.get();
      m_Diameter = diameter;
      
      m_Acceleration = new PVector(0, 0);
      
      m_Left = null;
      m_Right = null;
      
      m_Mass = 1.0f;
   }
   
   void Display()
   {
      pushMatrix();
      fill(0, 0,  255);
      noStroke();
      ellipse(m_Pos.x, m_Pos.y, m_Diameter, m_Diameter);
      popMatrix();
   } //<>// //<>// //<>//
   
   void AddForce(PVector force)
   {
      m_Acceleration = PVector.add(m_Acceleration, PVector.div(force, m_Mass));
   }
   
   float GetClosestDistanceToNodeSurface(PVector fromPos)
   {
      float radius = m_Diameter/2;
      float surfDist = m_Pos.dist(fromPos) - radius;
      
      return surfDist;
   }
   
   float GetIdealNeighbhourDistance()
   {
     float idealNeighbourDistance = 0.0f;
     int numNeighbours = 0;
     
     if (m_Left != null)
     {
       idealNeighbourDistance += m_Left.m_Pos.dist(m_Pos);
       ++numNeighbours;
     }
     
     if (m_Right != null)
     {
       idealNeighbourDistance += m_Right.m_Pos.dist(m_Pos);
       ++numNeighbours;
     }
     
     idealNeighbourDistance = idealNeighbourDistance/numNeighbours;
     return idealNeighbourDistance;
   }
}
