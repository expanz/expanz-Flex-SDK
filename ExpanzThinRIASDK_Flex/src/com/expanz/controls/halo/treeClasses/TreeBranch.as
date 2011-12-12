package com.expanz.controls.halo.treeClasses
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class TreeBranch
	{
		public function TreeBranch(id:int)
		{
			super();
			this.ID=id;
			Children = new Dictionary();
		}
		public var ID:int;
		public var Name:String;
		public var Hint:String;
		public var Type:String;
		public var Children:Dictionary;
		private var parentNode:TreeBranch;
		public function set ParentNode(p:TreeBranch):void
		{
			parentNode=p;
			parentNode.Children[this.ID]=this;
		}
		public function findById(id:int):TreeBranch
		{
			if (ID == id) return this;
			if (Children[id]!=null) return Children[id] as TreeBranch;
			for (var childId:Object in Children)
			{
				var branch:TreeBranch = Children[childId] as TreeBranch;
				var found:TreeBranch = branch.findById(id);
				if(found!=null) return found;
			}
			return null;
		}
		public function get ChildrenAsArrayCollection():ArrayCollection
		{
			var ret:ArrayCollection = new ArrayCollection();
			for (var childId:Object in Children)
			{
				var branch:TreeBranch = Children[childId] as TreeBranch;
				ret.addItem(branch);
			}
			return ret;
		}
		public function get HasChildren():Boolean
		{
			return ChildCount>0;
		}
		private function get ChildCount():int
		{
			var count:int;	
			for (var childId:Object in Children)
			{
				count++;
			}
			return count;
		}
	}
}