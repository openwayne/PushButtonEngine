/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package tests
{
   import com.pblabs.engine.core.NameManager;
   import com.pblabs.engine.core.TemplateManager;
   import com.pblabs.engine.debug.Logger;
   import com.pblabs.engine.entity.IEntity;
   import com.pblabs.engine.entity.PropertyReference;
   
   import flash.events.Event;
   
   import flexunit.framework.Assert;
   
   import org.flexunit.async.Async;
   
   import tests.helpers.TestComponentA;
   import tests.helpers.TestComponentB;

   /**
    * @private
    */
   public class LevelTests
   {
   	  [Test(async)]
      public function testLevelLoading():void
      {
         Logger.printHeader(null, "Running Level Loading and Instantiating Test");
         
         TemplateManager.instance.addEventListener(TemplateManager.LOADED_EVENT, Async.asyncHandler(this, onLevelLoaded, 2000 ));
         //TemplateManager.instance.addEventListener(TemplateManager.FAILED_EVENT, asyncHandler( onLevelLoadFailed, 2000 ));
         TemplateManager.instance.loadFile(PBEngineTestSuite.testLevel);
      }
      
      private function onLevelLoaded(event:Event, passthru:Object):void
      {
         Assert.assertTrue(TemplateManager.instance.getXML("TestTemplate1"));
         Assert.assertTrue(TemplateManager.instance.getXML("TestTemplate2"));
         Assert.assertTrue(TemplateManager.instance.getXML("CyclicalTestTemplate1"));
         Assert.assertTrue(TemplateManager.instance.getXML("CyclicalTestTemplate2"));
         Assert.assertTrue(TemplateManager.instance.getXML("TestEntity1"));
         Assert.assertTrue(TemplateManager.instance.getXML("TestEntity2"));
         Assert.assertTrue(TemplateManager.instance.getXML("SimpleGroup"));
         Assert.assertTrue(TemplateManager.instance.getXML("ComplexGroup"));
         Assert.assertTrue(TemplateManager.instance.getXML("CyclicalGroup1"));
         Assert.assertTrue(TemplateManager.instance.getXML("CyclicalGroup2"));
         
         var testTemplate1:IEntity = TemplateManager.instance.instantiateEntity("TestTemplate1");
         Assert.assertTrue(testTemplate1);
         Assert.assertEquals(19, testTemplate1.getProperty(_testValueAReference));
         Assert.assertEquals(null, NameManager.instance.lookup("TestTemplate1"));
         testTemplate1.destroy();
         
         var testTemplate2:IEntity = TemplateManager.instance.instantiateEntity("TestTemplate2");
         Assert.assertTrue(testTemplate2);
         Assert.assertEquals(43, testTemplate2.getProperty(_testValueAReference));
         testTemplate2.destroy();
         
         var cyclicalTemplate:IEntity = TemplateManager.instance.instantiateEntity("CyclicalTestTemplate1");
         Assert.assertEquals(null, cyclicalTemplate);
         
         var testEntity1:IEntity = TemplateManager.instance.instantiateEntity("TestEntity1");
         Assert.assertTrue(testEntity1);
         Assert.assertEquals(testEntity1, NameManager.instance.lookup("TestEntity1"));
         Assert.assertEquals(14, testEntity1.getProperty(_testValueAReference));
         Assert.assertEquals(81.347, testEntity1.getProperty(_testComplexXReference));
         Assert.assertEquals(92.762, testEntity1.getProperty(_testComplexYReference));
         
         var bComponent:TestComponentB = testEntity1.lookupComponentByType(TestComponentB) as TestComponentB;
         Assert.assertEquals(bComponent.getTestValueFromA(), 14);
         
         var testEntity2:IEntity = TemplateManager.instance.instantiateEntity("TestEntity2");
         Assert.assertTrue(testEntity2);
         Assert.assertEquals(testEntity2, NameManager.instance.lookup("TestEntity2"));
         Assert.assertEquals(638, testEntity2.getProperty(_testValueAReference));
         Assert.assertEquals(1036, testEntity2.getProperty(_testValueA2Reference));
         Assert.assertEquals(8.237, testEntity2.getProperty(_testComplexXReference));
         Assert.assertEquals(12.4, testEntity2.getProperty(_testComplexYReference));
         
         var aComponent:TestComponentA = testEntity2.lookupComponentByName("A") as TestComponentA;
         Assert.assertEquals(testEntity1, aComponent.namedReference);
         Assert.assertTrue(aComponent.instantiatedReference);
         Assert.assertEquals(bComponent, aComponent.componentReference);
         Assert.assertEquals(bComponent, aComponent.namedComponentReference);
         
         testEntity1.destroy();
         testEntity2.destroy();
         
         var testGroup1:Array = TemplateManager.instance.instantiateGroup("SimpleGroup");
         Assert.assertEquals(2, testGroup1.length);
         testGroup1[0].destroy();
         testGroup1[1].destroy();
         
         var testGroup2:Array = TemplateManager.instance.instantiateGroup("ComplexGroup");
         Assert.assertEquals(3, testGroup2.length);
         testGroup2[0].destroy();
         testGroup2[1].destroy();
         testGroup2[2].destroy();
         
         var cyclicalGroup:Array = TemplateManager.instance.instantiateGroup("CyclicalGroup1");
         Assert.assertEquals(null, cyclicalGroup);
         
         TemplateManager.instance.unloadFile(PBEngineTestSuite.testLevel);
         Assert.assertTrue(!TemplateManager.instance.getXML("TestTemplate1"));
         Assert.assertTrue(!TemplateManager.instance.getXML("TestTemplate2"));
         Assert.assertTrue(!TemplateManager.instance.getXML("CyclicalTestTemplate1"));
         Assert.assertTrue(!TemplateManager.instance.getXML("CyclicalTestTemplate2"));
         Assert.assertTrue(!TemplateManager.instance.getXML("TestEntity1"));
         Assert.assertTrue(!TemplateManager.instance.getXML("TestEntity2"));
         Assert.assertTrue(!TemplateManager.instance.getXML("SimpleGroup"));
         Assert.assertTrue(!TemplateManager.instance.getXML("ComplexGroup"));
         Assert.assertTrue(!TemplateManager.instance.getXML("CyclicalGroup1"));
         Assert.assertTrue(!TemplateManager.instance.getXML("CyclicalGroup2"));
         
         Logger.printFooter(null, "");
      }
      
      private function onLevelLoadFailed(event:Event):void
      {
         Assert.assertTrue(false);
         Logger.printFooter(null, "");
      }
      
      private var _testValueAReference:PropertyReference = new PropertyReference("@A.testValue");
      private var _testValueA2Reference:PropertyReference = new PropertyReference("@A2.testValue");
      private var _testComplexXReference:PropertyReference = new PropertyReference("@B.testComplex.x");
      private var _testComplexYReference:PropertyReference = new PropertyReference("@B.testComplex.y");
   }
}