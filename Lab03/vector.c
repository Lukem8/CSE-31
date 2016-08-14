/* Include the system headers we need */
#include <stdlib.h>
#include <stdio.h>

/* Include our header */
#include "vector.h"

/* Define what our struct is */
struct _vector_t {
	size_t size;
	int *data;
};

/* Create a new vector */
vector_t *vector_new() {
	vector_t *retval;  

	/* First, we need to allocate the memory for the struct */
	retval = (vector_t *)malloc(1 * sizeof(vector_t));

	/* Check our return value to make sure we got memory */
	if(retval == NULL)
		return NULL;

	/* Why does the above statement cast the malloc's return value to 'vector_t *'
	 * instead of 'struct _vector_t *'?  Does it matter?  
	 */
	 
	/* Now we need to initialize our data */
	retval->size = 1;
	retval->data = (int *)malloc(retval->size * sizeof(int));

	/* Check our return value to make sure we got memory */
	if(retval->data == NULL) {
		free(retval);
		return NULL;
	}

	retval->data[0] = 0;

	/* Note that 'retval->size' could be written '(*retval).size', but the ->
	 * convention is easier to read
	 */
	
	/* and return... */
	return retval;
}

/* Free up the memory allocated for the passed vector */
void vector_delete(vector_t *v) {
	/* Remember, you need to free up ALL the memory that is allocated */
	//int i;
	//for (i = 0; i < v->size; i++) {	
	if(v->data != NULL) 
		free(v->data);

	//}
	if(v != NULL)
		free(v);

	/* ADD CODE HERE */




}

/* Return the value in the vector */
int vector_get(vector_t *v, size_t loc) {

	/* If we are passed a NULL pointer for our vector, complain about it and
	 * return 0.
	 */
	if(v == NULL) {
		fprintf(stderr, "vector_get: passed a NULL vector.  Returning 0.\n");
		return 0;
	}

	/* If the requested location is higher than we have allocated, return 0.
	 * Otherwise, return what is in the passed location.
	 */
	if(loc < v->size) {
		return v->data[loc];
	} else {
		return 0;
	}
}

/* Set a value in the vector */
void vector_set(vector_t *v, size_t loc, int value) {
	/* What do you need to do if the location is greater than the size we have
	 * allocated?  Remember that unset locations should contain a value of 0.
	 */
	int i;
	if (v != NULL) {
		if (loc < v->size)
			v->data[loc] = value;
		if (loc >= v->size) {
			vector_t *v2;
			v2 = vector_new();
			v2->size = loc+1;
			//free(v2->data);
			v2->data = (int *)malloc(v2->size * sizeof(int));
		/*	for (i = 0; i < v2->size; i++) {
				v2->data[i] = 0;
			} */
			for (i = 0; i < v->size; i++) {
				v2->data[i] = v->data[i];
			}
			v2->data[loc] = value;
			free(v->data);
			free(v);
			//v2->data = (int *)malloc(v->size * sizeof(int));
			//v2->data[loc] = value;
			v = v2;
			free(v2->data);
			free(v2);
		}
		
	}
		


	/* ADD CODE HERE */




}
