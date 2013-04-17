namespace ms {
	
	struct List;
	struct ListNode;
	
	//----------------------------------------------------------
	struct List
	{
	private:
		ListNode *head;
		ListNode *tail;
	public:
		void init(){
			head = tail = NULL;
		}
		BOOL isEmpty() const{
			return (head == NULL) && (tail == NULL);
		}
		void addTail(ListNode *node);
		void addHead(ListNode *node);
		void insertBefore(ListNode *nodePosition, ListNode *nodeAdd);
		void insertAfter(ListNode *nodePosition, ListNode *nodeAdd);
		void replace(ListNode *nodePosition, ListNode *newNode);
		void remove(ListNode *node);
		int getCount() const;
		ListNode *getNode(int nIndex) const;
		ListNode *getHead() const {
			return head;
		}
		ListNode *getTail() const {
			return tail;
		}
		int getNodeIndex(const ListNode *targetNode) const;
		BOOL checkNode(const ListNode* node);
	};
	
	//----------------------------------------------------------
	struct ListNode
	{
	private:
		friend struct List;
		ListNode *next;
		ListNode *prev;
	public:
		void init() {
			next = prev = NULL;
		}
		ListNode* getNext() const {
			return next;
		}
		ListNode* getPrev() const {
			return prev;
		}
	};
};