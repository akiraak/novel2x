#include "MS.h"

namespace ms
{
	//--------------------------------------------------------------
	Object::Object(){
		notifyMessageChildList.init();
	}
	//--------------------------------------------------------------
	Object::~Object(){		
	}
	//--------------------------------------------------------------
	void Object::init(){
	}
	//--------------------------------------------------------------
	void Object::addChildNotifyMessage(NotifyNode& node){
		notifyMessageChildList.addTail(&node);
	}
	//--------------------------------------------------------------
	void Object::removeChildNotifyMessage(NotifyNode& node){
		notifyMessageChildList.remove(&node);
	}
	//--------------------------------------------------------------
	void Object::sendChildNotifyMessage(ms::Uint32 messageCode, void* messageOther){
		NotifyNode* node = (NotifyNode*)notifyMessageChildList.getHead();
		while(node){
			ms::Object* object = node->thisObject;
			object->onChildNotifyMessage(this, messageCode, messageOther);
			node = (NotifyNode*)node->getNext();
		}
	}
	//--------------------------------------------------------------
	void Object::onChildNotifyMessage(ms::Object* sender, ms::Uint32 messageCode, void* messageOther){
	}
};