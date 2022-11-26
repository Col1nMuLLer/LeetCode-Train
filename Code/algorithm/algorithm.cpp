#include <iostream>

using namespace std;

void quickSort (int nums[], int left, int right) {
    if(left>=right)
        return;
    
    int base = nums[left];
    int low = left;
    int high = right;
    // left++;
    while (left < right) {
        while (nums[right] >= base && left < right) {
            right--;
        }

        while (nums[left] <= base && left < right) {
            left++;
        }

        int temp = nums[right];
        nums[right] = nums[left];
        nums[left] = temp;
        // swap(nums[left], nums[right]);
    }
    nums[low] = nums[right];
    nums[right] = base;
    quickSort(nums, low, right - 1);
    quickSort(nums, right + 1, high);

}   

int main()
{
    cout<<"Hello World";
    int arr[7] = { 6, 4, 8, 9, 2, 3, 1};
    //cout<<sizeof(arr) / sizeof(arr[0]);
    quickSort(arr, 0, sizeof(arr) / sizeof(arr[0]) - 1);
    for (int i = 0; i < sizeof(arr) / sizeof(arr[0]); i++){
		  cout << arr[i] << " ";
	  }
    return 0;
}
