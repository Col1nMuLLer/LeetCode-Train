class Main {

    // top-left to bottle right, min length
    static ArrayList<Integer> arr = new ArrayList<>();

    public static void main(String[] args) {
        // int[][] test = { { 1, 3, 5, 9 },
        // { 8, 1, 3, 4 },
        // { 5, 0, 6, 1 },
        // { 8, 8, 4, 0 } };
        int[][] test = { { 1, 3, 1 }, { 1, 5, 1 }, { 4, 2, 1 } };
        System.out.println(minPathSum(test));
    }

    //
    public static int minPathSum(int[][] arr) {
        if (arr == null || arr.length == 0 || arr[0] == null || arr[0].length == 0) {
            return -1;
        }
        // O(min{M,N})
        int more = Math.max(arr.length, arr[0].length);
        int less = Math.min(arr.length, arr[0].length);
        boolean rowmore = arr.length == more;
        // with space compression
        int[] dp = new int[less];
        // int cur = arr[0][0];
        dp[0] = arr[0][0];
        for (int i = 1; i < less; i++) {
            dp[i] = dp[i - 1] + (rowmore ? arr[0][i] : arr[i][0]);
        }

        for (int i = 1; i < more; i++) {
            dp[0] = (rowmore ? arr[i][0] : arr[0][i]) + dp[0];
            for (int j = 1; j < less; j++) {
                dp[j] = Math.min(dp[j - 1], dp[j]) + (rowmore ? arr[i][j] : arr[j][i]);
            }
        }

        return dp[less - 1];
        // without space compression, space complexity: (n*m)
        // int row = arr.length;
        // int col = arr[0].length;
        // int[][] dp = new int[row][col];
        // dp[0][0] = arr[0][0];
        // for (int i = 1; i < row; i++) {
        // dp[i][0] = dp[i - 1][0] + arr[i][0];
        // }
        // for (int j = 1; j < col; j++) {
        // dp[0][j] = dp[0][j - 1] + arr[0][j];
        // }
        // for (int i = 1; i < row; i++) {
        // for (int j = 1; j < col; j++) {
        // dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + arr[i][j];
        // }
        // }

        // return dp[row - 1][col - 1];

    }
}
