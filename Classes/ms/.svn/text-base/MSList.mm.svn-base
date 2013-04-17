#include "MS.h"

namespace ms
{
	//--------------------------------------------------------------
	void List::addTail(ListNode *node){
		if(tail == NULL){
			head = tail = node;
			node->prev = node->next = NULL;
		}else{
			node->prev = tail;
			node->next = NULL;
			tail->next = node;
			tail = node;
		}
	}
	//--------------------------------------------------------------
	void List::addHead(ListNode *node){
		if(head == NULL)
		{
			head = tail = node;
			node->prev = node->next = NULL;
		}else{
			node->prev = NULL;
			node->next = head;
			head->prev = node;
			head = node;
		}
	}
	//--------------------------------------------------------------
	void List::insertBefore(ListNode *nodePosition, ListNode *nodeAdd){
		if((nodePosition == NULL) ||
		   (nodePosition->prev == NULL))
		{
			addHead(nodeAdd);
		}else{
			ListNode* prev = nodePosition->prev;
			prev->next = nodeAdd;
			nodeAdd->prev = prev;
			nodeAdd->next = nodePosition;
			nodePosition->prev = nodeAdd;
		}
	}
	//--------------------------------------------------------------
	void List::insertAfter(ListNode *nodePosition, ListNode *nodeAdd){
		if((nodePosition == NULL) ||
		   (nodePosition->next == NULL))
		{
			addTail(nodeAdd);
		}else{
			ListNode* next = nodePosition->next;
			nodePosition->next = nodeAdd;
			nodeAdd->prev = nodePosition;
			nodeAdd->next = next;
			next->prev = nodeAdd;
		}
	}
	//--------------------------------------------------------------
	void List::replace(ListNode *nodePosition, ListNode *nodeNew){
		ListNode *prev = nodePosition->prev;
		ListNode *next = nodePosition->next;
		if(prev == NULL){
			head = nodeNew;
		}else{
			prev->next = nodeNew;
		}
		if(next == NULL){
			tail = nodeNew;
		}else{
			next->prev = nodeNew;
		}
		nodeNew->prev = prev;
		nodeNew->next = next;
		nodePosition->next = nodePosition->prev = NULL;
	}
	//--------------------------------------------------------------
	void List::remove(ListNode *node){
		ListNode *prev = node->prev;
		ListNode *next = node->next;
		if(prev == NULL){
			head = next;
		}else{
			prev->next = next;
		}
		if(next == NULL){
			tail = prev;
		}else{
			next->prev = prev;
		}
		node->next = node->prev = NULL;
	}
	
	//--------------------------------------------------------------
	int List::getCount() const {
		const ListNode *node = head;
		int count = 0;
		while(node != NULL){
			count++;
			node = node->getNext();
		}
		return count;
	}
	
	//--------------------------------------------------------------
	ListNode *List::getNode(int index) const {
		ListNode *find = NULL;
		ListNode *node = head;
		int i = index;
		while(node != NULL){
			if(i == 0){
				find = node;
				break;
			}
			i--;
			node = node->getNext();
		}
		return find;
	}
	//--------------------------------------------------------------
	int List::getNodeIndex(const ListNode *targetNode) const {
		ListNode *node = head;
		int index = -1;
		int i = 0;
		while(node != NULL){
			if(node == targetNode){
				index = i;
				break;
			}
			i++;
			node = node->getNext();
		}
		return index;
	}
	
	//--------------------------------------------------------------
	BOOL List::checkNode(const ListNode* targetNode){
		return (getNodeIndex(targetNode) >= 0);
	}
};
