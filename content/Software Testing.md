# Software Development Lifecycle
**SDLC** (Software Development Lifecycle) is a term used by the software industry to define a process for designing, developing, testing, and maintaining a high quality software. Also known as **Software Development Process**.

## SDLC Cycle

![[Pasted image 20260210085946.png|450]]

1. **Planning -** Identifying customer/market needs and pursuing feasibility. Also includes requirements definition and requirements analysis.
2. **Design and Architecture -** Design defines the internals and implementation of each module while Architecture defines the connection between modules.
3. **Development -** Design documents are used to implement the product. Includes unit testing and debugging.
4. **Testing -** Software Integration and System Integration testing along with various other tests for all previous steps.
5. **Maintenance -** Fixing errors post-deployment and modifying features.

**Traceability-Matrix** is a document that links each artifact of the development phase to those of others.
## SDLC Models
1. **Waterfall Model -** 
	- Requirements -> Design -> Implementation -> Testing -> Maintenance
2. **V-Model -** Focuses on verification and validation.
	- Different from waterfall model as each phase has a direct mapping to a corresponding testing phase.
	- Requirements -> Design -> Implementation -> Testing -> Maintenance
3. **Agile-SD Methodologies -**  Adaptive and focus on fast delivery of features
	- Focus on individuals and components rather than processes and tools.
	- Working software over Careful documentation.
	- All SDLC steps are repeated in incremental iterations to deliver a set of features
	- Agile Sprints can look like this -

![[Pasted image 20260210100113.png|450]]
# Software Testing Terminologies
Software testing is the process of examining the artifacts and behavior of a software under test by validation and verification.

- **Validation -** Process of evaluating the software at the very end of the development to ensure compliance with the intended usage.
- **Verification -** Process of determining the products of each phase of the development cycle fulfill the requirements established at the start of the phase.
- **Fault -** A static defect in the software like missing code or function.
- **Failure -** An external incorrect behavior with respect to the description of the expected behavior.
- **Error -** An incorrect internal state during execution. This happens inside the memory.

A test case involves an input to the software and an output. If the actual output matches the expected output, we say that the test case passed.
## Types of testing
1. **Unit Testing -** Testing of a singular component.
2. **Integration Testing** - Various components are put together and tested.
3. **System Testing -** Done with full system implementation and platform on which the software will be running.
4. **Acceptance Testing -** Testing whether the software meets the committed requirements.
5. **Beta Testing -** Acceptance Testing but done by end users.

Additional Tests -
1. Functional Testing
2. Stress Testing
3. Performance Testing
4. Usability Testing
5. Regression Testing - Done after modifying a component to ensure the modification doesn't affect other components.

There are two broader methods of testing -
1. **White Box Testing -** Examining the artifacts with full knowledge about their implementation.
2. **Black Box Testing -** Examining the artifacts without knowledge of the internal workings.
# Graphs Structural Coverage
**Test paths -** Any path in the graph executed by a test case from the initial node to the final node.
## Types of Path coverages
1. **Node coverage -** When a test path covers all nodes in a graph.
2. **Edge coverage -** When a test path covers all edges in a graph. This subsumes node coverage.
3. **Edge Pair coverage -** When a test path covers all edge pairs in a graph. This subsumes edge coverage.
4. **Complete Path Coverage -** When a test path covers all possible paths from the entry to the exist in a graph. Not feasible as graphs can have loops, in which case there would exist infinite paths. This subsumes edge pair coverage.
## Types of Paths
1. **Simple Path -** A path from one node to another is a simple path if no node appears more than once except the first and last node. No internal loops.
2. **Prime Path -** A simple path such that it's not a sub-path of another simple path. They are thus the maximal simple paths.
## Types of Tours
1. Tours with side-trips
2. Tours with detours
# Data flow Coverage
1. **Variable def** - A definition is a location where a value of a variable is initialized.
2. **Variable use** - A use is a location where the variable is accessed.
3. **du-pair** - A du-pair is a pair of locations $(I_i, I_j)$ which mean that the variable was defined at $I_i$ and used at $I_j$.
4. **du-path -** A du-path with respect to a variable $v$ is a def-clear simple path from def of $v$ to use of $v$.
5. **du-path set -** A du-path set $\operatorname{du}(n_i, v)$ is a set of all du-paths w.r.t variable $v$ that start from node $n_i$.
6. **du-pair set -** A du-pair set $\operatorname{du}(n_i, n_j ,v)$ is a set of all du-paths w.r.t variable $v$ that start from node $n_i$ and end at node $n_j$. $\operatorname{du}(n_i,v) = \bigcup_{n_j}\operatorname{du}(n_i,n_j,v)$

![[Pasted image 20260222112558.png]]