package com.expanz.controls.halo.treeClasses
{
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;

	public class TreeDataDescriptor implements ITreeDataDescriptor
	{
		private var structure:TreeBranch;
		public function TreeDataDescriptor()
		{
			super();
			structure=new TreeBranch(0);
		}

		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			if(!(node is int))
			{
				throw new Error("object passed to TreeDataDescriptor.getChildren not an int");
			}
			var branch:TreeBranch = structure.findById(node as int);
			if(branch!=null) return branch.ChildrenAsArrayCollection;
			return null;
		}
		
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			if(!(node is int))
			{
				throw new Error("object passed to TreeDataDescriptor.hasChildren not an int");
			}
			var branch:TreeBranch = structure.findById(node as int);
			return branch.HasChildren;
		}
		
		public function isBranch(node:Object, model:Object=null):Boolean
		{
			return true;
		}
		
		public function getData(node:Object, model:Object=null):Object
		{
			return null;
		}
		
		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			return false;
		}
		
	}
}