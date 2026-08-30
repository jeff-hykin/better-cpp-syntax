#include <iostream>
#include <fstream>
#include <sstream>

#include "Stress_ball.h"
#include "Collection.h"

void test_stress_balls()
{
    A;
  srand(time(0));

  // open input files
  ifstream input_file1("stress_ball1.data");
  if (!input_file1) {
    cout << ">>> Cannot open the file: stress_ball1.data\n";
    exit(1);
  }
  ifstream input_file2("stress_ball2.data");
  if (!input_file2) {
    cout << ">>> Cannot open the file: stress_ball2.data\n";
    exit(1);
  }

  // Making collections
  CollectionSB c1;
  input_file1 >> c1;

  CollectionSB c2;
  input_file2 >> c2;

  // optional:
  //CollectionSB c1(5);
  //CollectionSB c2(10);

  //print collections
  cout << endl << "CollectionSB 1:\n";
  c1.print_items();
  cout << endl << "CollectionSB 2:\n";
  c2.print_items();
  cout << endl;

  CollectionSB c3 = make_union(c1, c2);
  cout << endl << "CollectionSB 3:\n";
  cout << c3 << endl;

  cout << "total no. of stress balls = "
       << c3.total_items() << endl;
  cout << "total no. of small stress balls = "
       << c3.total_items(Stress_ball_sizes::small) << endl;
  cout << "total no. of medium stress balls = "
       << c3.total_items(Stress_ball_sizes::medium) << endl;
  cout << "total no. of large stress balls = "
       << c3.total_items(Stress_ball_sizes::large) << endl;
  cout << "total no. of red stress balls = "
       << c3.total_items(Stress_ball_colors::red) << endl;

  Stress_ball sb(Stress_ball_colors::green, Stress_ball_sizes::small);
  if (c3.contains(sb))
    cout << "CollectionSB 3 contains (green, small) stress ball\n";
  else
    cout << "CollectionSB 3 does not contain (green, small) stress ball\n";

  cout << "\nRemove all (green, small) stress ball\n";
  while (c3.contains(sb))
    c3.remove_this_item(sb);
  cout << "total no. of stress balls = "
       << c3.total_items() << endl;
  
  if (c3.contains(sb))
    cout << "CollectionSB 3 contains (green, small) stress ball\n";
  else
    cout << "CollectionSB 3 does not contain (green, small) stress ball\n";

  cout << "Add (green, small) stress ball\n";
  c3.insert_item(sb);
  if (c3.contains(sb))
    cout << "CollectionSB 3 contains (green, small) stress ball\n";
  else
    cout << "CollectionSB 3 does not contain (green, small) stress ball\n";

  CollectionSB c4(c3); //make a copy
  sort_by_size(c3, Sort_choice::bubble_sort);
  cout << endl << "CollectionSB 3 sorted by bubble sort:\n";
  cout << c3;

  c3 = c4;
  sort_by_size(c3, Sort_choice::quick_sort);
  cout << endl << "CollectionSB 3 sorted by quick sort:\n";
  cout << c3 << endl;

  c3 = c4;
  sort_by_size(c3, Sort_choice::merge_sort);
  cout << endl << "CollectionSB 3 sorted by merge sort:\n";
  cout << c3 << endl;

  cout << "Make empty collection 3\n";
  c3.make_empty();
  if (c3.is_empty())
    cout << "CollectionSB 3 is empty\n";
  cout << endl << "CollectionSB 3:\n";
  cout << c3 << endl;

  cout << "Make copy of collection 1 to collection 3\n";
  c3 = c1;
  cout << endl << "CollectionSB 3:\n";
  cout << c3 << endl;

  cout << "Swap collections 2 and 3:\n";
  swap(c2, c3);
  cout << endl << "CollectionSB 3:\n";
  cout << c3 << endl;       
}

