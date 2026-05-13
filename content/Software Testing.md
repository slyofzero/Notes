>[!SUMMARY] Table of Contents
>- [[Software Testing#Software Development Lifecycle|Software Development Lifecycle]]
>	- [[Software Testing#SDLC Cycle|SDLC Cycle]]
>	- [[Software Testing#SDLC Models|SDLC Models]]
>- [[Software Testing#Software Testing Terminologies|Software Testing Terminologies]]
>	- [[Software Testing#Types of testing|Types of testing]]
>- [[Software Testing#Graphs Structural Coverage|Graphs Structural Coverage]]
>	- [[Software Testing#Types of Path coverages|Types of Path coverages]]
>	- [[Software Testing#Types of Paths|Types of Paths]]
>	- [[Software Testing#Types of Tours|Types of Tours]]
>- [[Software Testing#Data flow Coverage|Data flow Coverage]]
>- [[Software Testing#Test Integration|Test Integration]]
>	- [[Software Testing#Scaffolding|Scaffolding]]
>	- [[Software Testing#Five approaches to integration testing |Five approaches to integration testing ]]
>	- [[Software Testing#Coupling data flow|Coupling data flow]]
>	- [[Software Testing#Classical Coverage Criteria|Classical Coverage Criteria]]
>- [[Software Testing#Logic Coverage|Logic Coverage]]
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

Testing goals based on process maturity -
1. Level 0: There is no difference between testing and de-bugging.
2. Level 1: The purpose of testing is to show correctness.
3. Level 2: The purpose of testing is to show that software doesn’t work.
4. Level 3: The purpose of testing is not to prove anything specific, but to reduce the risk of using the software.
5. Level 4: Testing is a mental discipline that helps all IT professionals develop higher quality software.
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
4. **Prime Path Coverage -** When a test path covers all [[#^633cde|prime paths]] in a graph. The test requirements for prime path coverage are all the prime paths themselves.
5. **Complete Path Coverage -** When a test path covers all possible paths from the entry to the exist in a graph. Not feasible as graphs can have loops, in which case there would exist infinite paths. This subsumes edge pair coverage.
## Types of Paths
1. **Simple Path -** A path from one node to another is a simple path if no node appears more than once except the first and last node. No internal loops.
2. **Prime Path -** A simple path such that it's not a sub-path of another simple path. They are thus the maximal simple paths. ^633cde
## Types of Tours
1. **Tours with side-trips** - A test path $p$ tours a sub-path $q$ with side-trips iff every edge in $q$ is also in $p$ in the same order.  If a tour comes back to the same node it diverted from, we say the tour includes a side-trip.

![[Pasted image 20260225093645.png|450]]

2. **Tours with detours** - A test path $p$ tours a sub-path $q$ with detours iff every node in $q$ is also in $p$ in the same order.  If a tour detours from some node $n$ and returns back to the prime path at a successor of $n$, we say the tour has a detour.

![[Pasted image 20260225093700.png|450]]
# Data flow Coverage
1. **Variable def** - A definition is a location where a value of a variable is initialized.
2. **Variable use** - A use is a location where the variable is accessed.
3. **du-pair** - A du-pair is a pair of locations $(I_i, I_j)$ which mean that the variable was defined at $I_i$ and used at $I_j$.
4. **def-clear -** A path from $I_i$ to $I_j$ is said to be def-clear w.r.t variable $v$, if $v$ is not given another value on any of the nodes or edges in the path. ($v$ is not redefined in the path except at $I_i$)
5. **du-path -** A du-path with respect to a variable $v$ is a def-clear simple path from def of $v$ to use of $v$.
6. **du-path set -** A du-path set $\operatorname{du}(n_i, v)$ is a set of all du-paths w.r.t variable $v$ that start from node $n_i$.
7. **du-pair set -** A du-pair set $\operatorname{du}(n_i, n_j ,v)$ is a set of all du-paths w.r.t variable $v$ that start from node $n_i$ and end at node $n_j$. $\operatorname{du}(n_i,v) = \bigcup_{n_j}\operatorname{du}(n_i,n_j,v)$

![[Pasted image 20260222112558.png]]
# Test Integration
## Scaffolding
When testing incomplete portions of software, we need extra software components, sometimes called scaffolding.
Two common types of scaffolding:
1. **Test stub** is a skeletal or special purpose implementation of a software module, used to develop or test a component that calls the stub or otherwise depends on it.
2. **Test driver** is a software component or test tool that replaces a component that takes care of the control and/or the calling of a software component.
## Five approaches to integration testing 
1. **Incremental -**
	1. Top-down - Create top level modules while using stubs.
	2. Bottom-up - Create bottom level modules while using test drivers to call them.
2. **Sandwich** - Mix of top-down and bottom-up
3. **Big Bang** - all individually tested modules are put together to construct the entire system which is tested as a whole. 
## Coupling data flow
Coupling variables are variables that are defined in one unit and used in the other.
There are different kinds of couplings based on the interfaces:
- **Parameter coupling:** Parameters are passed in calls.
- **Shared data coupling:** Two units access the same data through global or shared variables.
- **External device coupling:** Two units access an external object like a file.
- **Message-passing interfaces:** Two units communicate by sending and/or receiving messages over buffers/channels.

A coupling du-path is from a last-def to a first-use.
Data flow coverage criteria can now be extended to coupling variables:
- **All-coupling-def coverage:** A path is to be executed from every last-def to at least one first-use.
- **All-coupling-use coverage:** A path is to be executed from every last-def to every first-use.
- **All-coupling-du-paths coverage:** Every simple path from every last-def to every first-use needs to be executed.
## Classical Coverage Criteria
Traditional terminologies - 
- **A linearly independent path** of execution in the CFG of a program is a path that does not contain other paths within it. (very similar to prime paths)
- **Basic Block -** A series of nodes with no branching can be collapsed into one node called the basic block.
- **Cyclomatic Complexity/Number** measures how complex a software is, in terms of its structure (specifically branching). It represents the number of **linearly independent paths** in the graph.
  
  If the number is $\lt 10$ then it's not considered complex.
  
  It is calculated as $M = E - N + 2P$, where
	-  $E =$ no. of edges
	- $N =$ no. of nodes
	- $P =$ no. of connected components

- A **chain** is a path in which Initial and terminal vertices are distinct. All the interior vertices have both in-degree and out-degree as $1$.
- A **maximal chain** is a chain that is not a part of any other chain.
# Logic Coverage
Let $P$ be a set of predicates and $C$ be a set of clauses in the predicates in $P$.
- $(x > y) ∨ C ∨ f (z)$ is a predicate.
- $(x > y), C,$ and $f(z)$ in the above predicate are clauses.

Types of coverages -
1. **Predicate coverage (PC):** Each predicate needs to evaluate to true or false. For a set of predicates associated with branches, predicate coverage is the same as edge coverage.
2. **Clause Coverage (CC):**  Each clause in the set of predicates needs to evaluate to true and false. Doesn't subsume predicate coverage.
3. **Combinatorial Coverage (CoC):** Covering all possible combinations of truth values for all clauses in a predicate. Not feasible as for $n$ clauses there would be $2^n$ combinations.

Clauses -
1. At any given time we are interested in one clause, we call this a **major clause**.
2. Rest all clauses are **minor clauses**.
3. A clause is **"active"** when it alone determines the outcome of the whole predicate.
## Active Clause Coverage (ACC)
ACC works this way -
1. TR has requirements for each clause to be a major clause.
2. For the rest minor clauses, make them assume a value such that they don't determine the value of the predicate.
3. Make the major clause assume both **True and False** and see if it influences the value of the predicate.

MCDC (Modified Condition Decision Coverage) is another testing criteria similar to ACC. 

Types of ACC -
1. GACC (General ACC) - 
	- The minor clause values don't need to be the same for each value of the major clause.
	- Doesn't subsume predicate coverage.
2. CACC (Correlated ACC) - 
	- We deliberately pick such values of the minor clause(s) that cause $p$ to be true for one value of the major clause and false for another. 
	- Because of how we are picking our clauses, this by definition **subsumes predicate coverage**.
	- Subsumes GACC.
3. RACC (Restricted ACC) - 
	- Values chosen for minor clauses should be the same for both values of the major clause.
	- Doesn't subsume predicate coverage.
	- Subsumes GACC.

XOR is the **test for activity** — if `p(a=true) XOR p(a=false) = true`, the clause is active. You still need to figure out minor clause values by reasoning about the predicate structure.
## Inactive Clause Coverage (ICC)
Complementary criterion to active clause criteria, ensures that the major clause does not affect the predicate.
- Choose minor clauses in such a way that the major clause doesn't determine $p$.
- TR has four requirements for $c_i$
	1. $c_i$ evaluates to true with $p$ true.
	2. $c_i$ evaluates to false with $p$ true.
	3. $c_i$ evaluates to true with $p$ false.
	4. $c_i$ evaluates to false with $p$ false.

Types of ICC -
1. GICC (General ICC) -
	- The values chosen for the minor clauses may vary among the four cases.
2. RICC (Restricted ICC) -
	- The values chosen for the minor clauses must be the same in (1), (2) and in (3), (4).

CICC is not a thing because it's impossible due to the definitions.

![[Pasted image 20260402190612.png|450]]

# Client-Side Testing
## Bypass Testing
The basic idea in bypass testing is to let a tester save and modify the HTML.

Types -
- **Value level bypass testing** tries to verify if a web application adequately evaluates invalid inputs.
- **Parameter level bypass testing** tries to check for issues related to relationships among different parameters of an input.
- **Control flow level bypass testing** tries to verify web applications by executing test cases that break the normal execution sequence.
# Server-Side Testing
If server-side source code is available, we an use graph models to test the server.
- Component Interaction Model (CIM)
- Application Transition Graph (ATG)

An **atomic section** is a section of HTML with the property that if any part of the section is sent to a client, the entire section is.
- A **content variable** is a program variable that provides data to an atomic section.