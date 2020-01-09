class Node
{
   PVector m_Pos;
   PVector m_PrevPos;
   float m_Diameter;
   
   PVector m_Acceleration;
   
   float m_Mass;
   
   Node(PVector position, float diameter)
   {
      m_Pos = position.get();
      m_PrevPos = m_Pos.get();
      m_Diameter = diameter;
      
      m_Acceleration = new PVector(0, 0);
      
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
}
